//
//  RecordingViewModel.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/06.
//

import AVFoundation
import Combine

final class RecordingViewModel {
    struct Input {
        let recordButtonPublisher: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let recordingError: AnyPublisher<Void, Error>
    }
    
    let videoRecordingService: VideoRecordingService
    
    init(videoRecordingService: VideoRecordingService) {
        self.videoRecordingService = videoRecordingService
    }
    
    func captureSession() -> AVCaptureSession {
        videoRecordingService.getCaptureSession()
    }
    
    func configureSession() throws {
        try videoRecordingService.configureSession()
    }
    
    func runCaptureSession() {
        videoRecordingService.runSession()
    }
    
    func transform(input: Input) -> Output {
        let recordingError = input.recordButtonPublisher
            .tryCompactMap { [weak self] in
                guard let self,
                      let isRecording = self.videoRecordingService.isRecording else {
                    return
                }
                
                if isRecording {
                    self.videoRecordingService.stopRecording()
                } else {
                    try self.videoRecordingService.startRecording()
                }
            }
            .eraseToAnyPublisher()
        
        return Output(recordingError: recordingError)
    }
}
