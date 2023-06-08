//
//  RecordingViewModel.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/06.
//

import AVFoundation
import Combine

protocol EventHandleable {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

final class RecordingViewModel: EventHandleable {
    let videoRecordingService: VideoRecordingService
    
    init(videoRecordingService: VideoRecordingService) {
        self.videoRecordingService = videoRecordingService
    }
    
    func previewLayer() -> AVCaptureVideoPreviewLayer {
        videoRecordingService.previewLayer()
    }
    
    func configureSession() throws {
        try videoRecordingService.configureSession()
    }
    
    func startCaptureSession() {
        videoRecordingService.startSession()
    }
    
    struct Input {
        let recordButtonTapped: AnyPublisher<Void, Never>
        let switchCameraButtonTapped: AnyPublisher<Void, Never>
        let closeButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let recordingError: AnyPublisher<Void, Error>
        let switchingError: AnyPublisher<Void, Error>
        let isDismissNeeded: AnyPublisher<Bool, Never>
    }
    
    func transform(input: Input) -> Output {
        let recordingError = input.recordButtonTapped
            .tryCompactMap { [weak self] in
                guard let isRecording = self?.videoRecordingService.isRecording else {
                    return
                }
                if isRecording {
                    self?.videoRecordingService.stopRecording()
                } else {
                    try self?.videoRecordingService.startRecording()
                }
            }
            .eraseToAnyPublisher()
        
        let cameraSwitched = input.switchCameraButtonTapped
            .tryCompactMap { [weak self] in
                try self?.videoRecordingService.switchCameraType()
            }
            .eraseToAnyPublisher()
        
        let isDismissNeeded = input.closeButtonTapped
            .compactMap { [weak self] in
                guard let isRecording = self?.videoRecordingService.isRecording else {
                    return true
                }
                
                if isRecording {
                    return false
                } else {
                    self?.videoRecordingService.stopSession()
                    return true
                }
            }
            .eraseToAnyPublisher()
        
        return Output(recordingError: recordingError,
                      switchingError: cameraSwitched,
                      isDismissNeeded: isDismissNeeded)
    }
}
