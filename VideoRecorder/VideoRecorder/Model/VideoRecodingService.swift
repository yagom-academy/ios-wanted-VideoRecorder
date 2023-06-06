//
//  VideoRecodingService.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/05.
//

import AVFoundation

protocol VideoRecordingDelegate: AnyObject {
    
}

final class VideoRecodingService: NSObject {
    enum RecordingError: Error {
        case unavailableCaptureDevice
        case nonexistInputDevice
        case invalidFileURL
    }
    
    private let captureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = .high
        
        return session
    }()
    
    private let videoDevice = AVCaptureDevice.default(for: .video)
    private let audioDevice = AVCaptureDevice.default(for: .audio)
    
    private var deviceOrientation: AVCaptureVideoOrientation
    private var videoInput: AVCaptureDeviceInput?
    private var audioInput: AVCaptureDeviceInput?
    private var videoOutput: AVCaptureMovieFileOutput?
    
    weak var delegate: VideoRecordingDelegate?
    
    init(deviceOrientation: AVCaptureVideoOrientation) {
        self.deviceOrientation = deviceOrientation
    }
    
    func getCaptureSession() -> AVCaptureSession {
        return self.captureSession
    }
    
    func configureSession() throws {
        guard let videoDevice, let audioDevice else {
            throw RecordingError.unavailableCaptureDevice
        }
        
        captureSession.beginConfiguration()
        let videoInput = try AVCaptureDeviceInput(device: videoDevice)
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        let audioInput = try AVCaptureDeviceInput(device: audioDevice)
        if captureSession.canAddInput(audioInput) {
            captureSession.addInput(audioInput)
        }
        captureSession.commitConfiguration()
    }
    
    func startRecording() throws {
        guard let device = videoInput?.device else {
            throw RecordingError.nonexistInputDevice
        }
        guard let outputURL = tempURL() else {
            throw RecordingError.invalidFileURL
        }
        
        let connection = videoOutput?.connection(with: .video)
        
        if connection?.isVideoOrientationSupported == false {
            connection?.videoOrientation = self.deviceOrientation
        }
        
        if device.isSmoothAutoFocusSupported {
            try device.lockForConfiguration()
            device.isSmoothAutoFocusEnabled = false
            device.unlockForConfiguration()
        }
        
        videoOutput?.startRecording(to: outputURL, recordingDelegate: self)
    }
    
    func stopRecording() {
        videoOutput?.stopRecording()
    }
    
    func change(orientation: AVCaptureVideoOrientation) {
        self.deviceOrientation = orientation
    }
    
    private func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
}

extension VideoRecodingService: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
    }
}
