//
//  RecordVideoViewModel.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/07.
//

import Combine
import AVFoundation

final class RecordVideoViewModel {
    private let recorder = Recorder()
    private let videoRecorderService = VideoRecorderService.shared
    private let timerManager = TimerManager()
    
    var isImageButtonTapped: Bool = false  {
        didSet { /* Todo */ }
    }
    var isRecordButtonTapped: Bool = false {
        didSet { recordVideo() }
    }
    var isRotateButtonTapped: Bool = false {
        didSet { rotateCamera() }
    }
    var recorderCaptureSession: AVCaptureSession {
        get {
            recorder.captureSession
        }
    }
    private var video: Video? {
        didSet { addVideo() }
    }
    private var videoData: Data?
    private var date: Date?
    var title: String? {
        didSet { createVideoIfNeeded() }
    }
    private var runCountText: String?
    
    @Published var isRecordingDoneButtonTapped: Bool = false
    @Published var isRecordingDone: Bool = false
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        recorder.configureCamera(isFrontCamera: false)
        bind()
    }
    
    private func bind() {
        recorder.$videoData
            .sink { [weak self] data in
                self?.videoData = data
                self?.createVideoIfNeeded()
            }
            .store(in: &subscriptions)
        
        recorder.$date
            .sink { [weak self] date in
                self?.date = date
                self?.createVideoIfNeeded()
            }
            .store(in: &subscriptions)
    }
    
    func runCountPublisher() -> AnyPublisher<Double, Never> {
        return timerManager.$runCount
            .eraseToAnyPublisher()
    }
        
    func startCaptureSession() {
        recorder.startCaptureSession()
    }
    
    func stopCaptureSession() {
        recorder.stopCaptureSession()
    }
    
    private func rotateCamera() {
        let isFrontCamera = isRotateButtonTapped
        
        recorder.configureCamera(isFrontCamera: isFrontCamera)
    }
    
    private func recordVideo() {
        if isRecordButtonTapped {
            recorder.startRecording()
            timerManager.start()
        } else {
            recorder.stopRecording()
    
            let runCount = timerManager.getRunCountAndStop()
            let time = CMTime(seconds: runCount, preferredTimescale: 1)
            runCountText = time.formattedTime
            
            isRecordingDoneButtonTapped = true
        }
    }
    
    private func createVideoIfNeeded() {
        guard let videoData, let date, let title else { return }
        
        video = Video(data: videoData, title: title, date: date)
        isRecordingDone = true
    }
    
    func addVideo() {
        guard let video else { return }
        
        videoRecorderService.create(video: video)
    }
}
