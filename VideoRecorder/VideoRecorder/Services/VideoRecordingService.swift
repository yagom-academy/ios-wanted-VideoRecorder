//
//  VideoRecordingService.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/05.
//

import AVFoundation

protocol VideoRecordingDelegate: AnyObject {
    
}

final class VideoRecordingService: NSObject {
    enum RecordingError: Error {
        case noneUsableCaptureDevice
        case nonexistInputDevice
        case invalidFileURL
    }
    
    private let captureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = .high
        
        return session
    }()
    
    private lazy var videoDevice = bestCamera(for: .back)
    private let audioDevice = AVCaptureDevice.default(for: .audio)
    
    private var deviceOrientation: AVCaptureVideoOrientation
    private var videoInput: AVCaptureDeviceInput?
    private var audioInput: AVCaptureDeviceInput?
    private var videoOutput: AVCaptureMovieFileOutput?
    
    var isRecording: Bool? {
        get {
            videoOutput?.isRecording
        }
    }
    
    weak var delegate: VideoRecordingDelegate?
    
    init(deviceOrientation: AVCaptureVideoOrientation) {
        self.deviceOrientation = deviceOrientation
    }
    
    func getCaptureSession() -> AVCaptureSession {
        return self.captureSession
    }
    
    func configureSession() throws {
        guard let videoDevice, let audioDevice else {
            throw RecordingError.noneUsableCaptureDevice
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
    
    func runSession() {
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
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
    
    func switchCameraType() throws {
        let input = captureSession.inputs.first { input in
            guard let input = input as? AVCaptureDeviceInput else {
                return false
            }
            return input.device.hasMediaType(.video)
        }
        
        guard let currentInput = input as? AVCaptureDeviceInput else {
            throw RecordingError.nonexistInputDevice
        }
        
        captureSession.beginConfiguration()
        captureSession.removeInput(currentInput)
        
        let newCameraDevice = currentInput.device.position == .back ? bestCamera(for: .front) : bestCamera(for: .back)
        
        guard let newCameraDevice else {
            throw RecordingError.noneUsableCaptureDevice
        }
        
        let newVideoInput = try AVCaptureDeviceInput(device: newCameraDevice)
        captureSession.addInput(newVideoInput)
        captureSession.commitConfiguration()
    }
    
    private func bestCamera(for position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let deviceTypes: [AVCaptureDevice.DeviceType] = [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera]
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: deviceTypes,
            mediaType: .video,
            position: .unspecified
        )
        let devices = discoverySession.devices
        
        return devices.first(where: { $0.position == position })
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

extension VideoRecordingService: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
    }
}
