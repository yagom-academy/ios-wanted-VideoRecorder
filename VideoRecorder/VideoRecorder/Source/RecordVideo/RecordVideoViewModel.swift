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
    var isImageButtonTapped: Bool = false  {
        didSet {  }
    }
    
    var isRecordButtonTapped: Bool = false {
        didSet {
            recordVideo()
        }
    }
    
    var isRotateButtonTapped: Bool = false {
        didSet {
            rotateCamera()
        }
    }
    
    var recorderCaptureSession: AVCaptureSession {
        get {
            recorder.captureSession
        }
    }
    
    @Published var isRecordDone = false
    
    var imageURL: URL?
    var title: String?
    var date: String?
    
    init() {
        recorder.configureCamera(isFrontCamera: false)
    }
        
    func startCaptureSession() {
        recorder.startCaptureSession()
    }
    
    private func rotateCamera() {
        let isFrontCamera = isRotateButtonTapped
        
        recorder.configureCamera(isFrontCamera: isFrontCamera)
    }
    
    private func recordVideo() {
        if isRecordButtonTapped {
            recorder.startRecording()
        } else {
            recorder.stopRecording()
            isRecordDone = true
        }
    }
}
