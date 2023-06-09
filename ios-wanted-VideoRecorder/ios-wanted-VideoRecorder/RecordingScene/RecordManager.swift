//
//  RecordManager.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/08.
//

import AVFoundation

final class RecordManager {
    enum RecordingError: Error {
        case noneCamera
        case noneAudioDevice
        case noneCameraInput
        case noneAudioInput
        case noneVideoOutput
    }
    
    let captureSession = AVCaptureSession()
    var videoOutput: AVCaptureMovieFileOutput?
    var outputURL: URL?
    
    func setupCamera() throws {
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else {
            throw RecordingError.noneCamera
        }
        
        guard let backInput = try? AVCaptureDeviceInput(device: backCamera),
              captureSession.canAddInput(backInput) else {
            throw RecordingError.noneCameraInput
        }
        
        videoOutput = AVCaptureMovieFileOutput()
        guard let videoOutput else {
            throw RecordingError.noneVideoOutput
        }
        
        captureSession.addInput(backInput)
        captureSession.addOutput(videoOutput)
    }
    
    func setupAudio(with permission: Bool) throws {
        guard let audio = AVCaptureDevice.default(for: .audio) else {
            throw RecordingError.noneAudioDevice
        }
        
        guard let audioInput = try? AVCaptureDeviceInput(device: audio),
              captureSession.canAddInput(audioInput) else {
            throw RecordingError.noneAudioInput
        }
        
        captureSession.addInput(audioInput)
    }
    
    func startCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func processRecording(delegate: AVCaptureFileOutputRecordingDelegate) {
        guard let videoOutput else { return }
        
        if !videoOutput.isRecording {
            let connection = videoOutput.connection(with: AVMediaType.video)
            connection?.videoOrientation = .portrait
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let uniqueFileName = UUID().uuidString + ".mp4"
            let outputFileURL = documentsDirectory?.appendingPathComponent(uniqueFileName)
            
            guard let outputFileURL else { return }
            
            videoOutput.startRecording(to: outputFileURL, recordingDelegate: delegate)
        } else {
            stopRecording()
        }
    }
    
    func stopRecording() {
        videoOutput?.stopRecording()
    }
    
    func switchCamera() {
        guard videoOutput?.isRecording == false else { return }
        
        captureSession.beginConfiguration()
        let currentVideoInput = captureSession.inputs.first(where: { input in
            guard let input = input as? AVCaptureDeviceInput else {
                return false
            }
            
            return input.device.hasMediaType(.video)
        }) as? AVCaptureDeviceInput
        
        guard let currentVideoInput else { return }
        
        captureSession.removeInput(currentVideoInput)
        
        guard let newCameraDevice = currentVideoInput.device.position == .back ? camera(with: .front) : camera(with: .back) else {
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
            deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera, .builtInTrueDepthCamera],
            mediaType: .video,
            position: .unspecified
        )
        let devices = discoverySession.devices
        
        return devices.first(where: { device in device.position == position })
    }
}
