//
//  RecordingViewModel.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/06.
//

import AVFoundation
import Combine

final class RecordingViewModel {
    let videoRecordingService: VideoRecodingService
    
    init(videoRecordingService: VideoRecodingService) {
        self.videoRecordingService = videoRecordingService
    }
    
    func captureSession() -> AVCaptureSession {
        self.videoRecordingService.getCaptureSession()
    }
}
