//
//  Recorder.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/08.
//

import AVFoundation
import Combine

final class Recorder: NSObject {
    let captureSession = AVCaptureSession()
    private var camera: AVCaptureDevice?
    private let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInUltraWideCamera, .builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera], mediaType: .video, position: .unspecified)
    private let videoOutput = AVCaptureMovieFileOutput()
    
    @Published var videoData: Data?
    @Published var date: Date?
    
    func configureCamera(isFrontCamera: Bool) {
        if isFrontCamera {
            camera = discoverySession.devices.first { device in
                device.position == .front
            }
        } else {
            camera = discoverySession.devices.first { device in
                device.position == .back
            }
        }
        
        setUpCaptureSession()
    }
    
    private func setUpCaptureSession() {
        do {
            captureSession.beginConfiguration()
            
            guard let camera else { return }
            
            let videoInput = try AVCaptureDeviceInput(device: camera)
            
            captureSession.inputs.forEach {
                captureSession.removeInput($0)
            }
            
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }

            guard let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio) else { return }

            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if captureSession.canAddInput(audioInput) {
              captureSession.addInput(audioInput)
            }

            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            
            captureSession.commitConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func startCaptureSession() {
        DispatchQueue.global().async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    func stopCaptureSession() {
        captureSession.stopRunning()
    }
    
    func startRecording() {
        guard let url = URL.createVideoURL() else { return }
        
        videoOutput.startRecording(to: url, recordingDelegate: self)
    }
    
    func stopRecording() {
        if videoOutput.isRecording {
            videoOutput.stopRecording()
        }
    }
}

extension Recorder: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        do {
            videoData = try Data(contentsOf: outputFileURL)
            date = Date()
        } catch {
            print(error.localizedDescription)
        }
    }
}
