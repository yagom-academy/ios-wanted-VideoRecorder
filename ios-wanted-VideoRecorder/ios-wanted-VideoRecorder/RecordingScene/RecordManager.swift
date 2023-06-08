//
//  RecordManager.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/08.
//

import AVFoundation

final class RecordManager {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        <#code#>
    }
    
    enum RecordingError: Error {
        case noneCamera
        case noneAudioDevice
        case noneCameraInput
        case noneAudioInput
        case noneVideoOutput
    }
    
    let captureSession = AVCaptureSession()
//    var videoDevice: AVCaptureDevice?
//    var audioDevice: AVCaptureDevice?
//    var videoInput: AVCaptureDeviceInput?
    var audioInput: AVCaptureDeviceInput?
    var videoOutput: AVCaptureMovieFileOutput?
    var outputURL: URL?
    
    func setupCamera() throws {
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else {
            throw RecordingError.noneCamera
        }
//        videoDevice = backCamera
        
        guard let audio = AVCaptureDevice.default(for: .audio) else {
            throw RecordingError.noneAudioDevice
        }
//        audioDevice = audio
        
        guard let backInput = try? AVCaptureDeviceInput(device: backCamera),
              captureSession.canAddInput(backInput) else {
            throw RecordingError.noneCameraInput
        }
//        videoInput = backInput
        
        guard let audioInput = try? AVCaptureDeviceInput(device: audio),
              captureSession.canAddInput(audioInput) else {
            throw RecordingError.noneAudioInput
        }
        self.audioInput = audioInput
        
        videoOutput = AVCaptureMovieFileOutput()
        guard let videoOutput else {
            throw RecordingError.noneVideoOutput
        }
        
        captureSession.addInput(backInput)
        captureSession.addInput(audioInput)
        captureSession.addOutput(videoOutput)
    }
    
    func startCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func processRecording(delegate: AVCaptureFileOutputRecordingDelegate) {
        guard let videoOutput else { return }
        
        if videoOutput.isRecording {
            let connection = videoOutput.connection(with: AVMediaType.video)
            connection?.videoOrientation = .portrait
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let uniqueFileName = UUID().uuidString + ".mp4"
            let outputFileURL = documentsDirectory?.appendingPathComponent(uniqueFileName)
            
            guard let outputFileURL else { return }
            
            videoOutput.startRecording(to: outputFileURL, recordingDelegate: delegate)
        }
    }
    
    func switchCamera() {
        captureSession.beginConfiguration()
        guard let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput else { return }
        captureSession.removeInput(currentInput)
        
        guard let newCameraDevice = currentInput.device.position == .back ? camera(with: .front) : camera(with: .back) else {
            return
        }
        guard let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice) else {
            return
        }
        
        captureSession.addInput(newVideoInput)
        captureSession.commitConfiguration()
    }
    
    private func camera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera],
            mediaType: .video,
            position: .unspecified
        )
        let devices = discoverySession.devices
        
        return devices.first(where: { device in device.position == position })
    }
}
