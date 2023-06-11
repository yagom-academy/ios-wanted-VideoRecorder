//
//  RecordingViewModel.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/09.
//
import AVFoundation
import Combine

final class RecordingViewModel: NSObject {
    @Published var secondsOfTimer = 0
    let historyImagePublisher = PassthroughSubject<CGImage, Never>()
    private var savedTime = 0
    private let recordManager: RecordManager
    private let videoGenreator: VideoGenerator
    private let createVideoUseCase: CreateVideoUseCaseProtocol
    private var isAccessDevice = true
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    
    struct Input {
        let recordingButtonTappedEvent: AnyPublisher<Void, Never>
        let cameraSwitchButtonTappedEvent: AnyPublisher<Void, Never>
        let dismissButtonTappedEvent: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let isRecording = PassthroughSubject<Bool?, Never>()
        let dismissTrigger = PassthroughSubject<Void, Never>()
    }
    
    init(
        recordManager: RecordManager,
        videoGenerator: VideoGenerator,
        createVideoUseCase: CreateVideoUseCaseProtocol
    ) {
        self.recordManager = recordManager
        self.videoGenreator = videoGenerator
        self.createVideoUseCase = createVideoUseCase
    }
    
    func setupDevice() throws {
        try recordManager.setupCamera()
        try recordManager.setupAudio()
    }
    
    func makePreview(size: CGSize) -> AVCaptureVideoPreviewLayer {
        let preview = recordManager.makePreview(size: size)
        return preview
    }
    
    func startCaptureSession() {
        recordManager.startCaptureSession()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }
            self.secondsOfTimer += 1
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        savedTime = secondsOfTimer
        secondsOfTimer = 0
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.recordingButtonTappedEvent
            .sink { [weak self] in
                guard let self, isAccessDevice else { return }
                self.recordManager.processRecording(delegate: self)
                output.isRecording.send(self.recordManager.isRecording)
            }
            .store(in: &cancellables)
        
        input.cameraSwitchButtonTappedEvent
            .sink { [weak self] in
                guard let self, isAccessDevice else { return }
                self.recordManager.switchCamera()
            }
            .store(in: &cancellables)
        
        input.dismissButtonTappedEvent
            .sink {
                output.dismissTrigger.send(())
            }
            .store(in: &cancellables)
        
        return output
    }
}

extension RecordingViewModel: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        recordManager.generateThumbnail(videoURL: outputFileURL) { [weak self] cgImage in
            guard let self, let cgImage else { return }
            self.historyImagePublisher.send(cgImage)
            let videoEntity = videoGenreator.makeVideo(
                videoURL: outputFileURL,
                duration: savedTime
            )
            ImageFileManager.shared.saveImageToDocumentDirectory(
                image: cgImage,
                fileName: videoEntity?.thumbnail
            )
            
            guard let videoEntity else { return }
            
            print(videoEntity.id)
            _ = createVideoUseCase.createVideo(videoEntity)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print(error.localizedDescription)
                    }
                } receiveValue: { _ in }
                .store(in: &cancellables)
        }
    }
}
