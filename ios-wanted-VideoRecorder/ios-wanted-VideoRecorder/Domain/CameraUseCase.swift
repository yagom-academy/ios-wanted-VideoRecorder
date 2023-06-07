//
//  CameraUseCase.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/06.
//

import Foundation
import AVFoundation

final class CameraUseCase: NSObject {
    
    private enum RecordState {
        case idle, start, recording, end
    }
    
    var fileURL: URL?
    var fileName: String = ""
    let session = AVCaptureSession()
    var isCameraPermission = false
    private let videoType = ".mov"
    private var videoDeviceInput: AVCaptureDeviceInput?
    private var videoOutput: AVCaptureVideoDataOutput?
    
    private var captureStatus: RecordState = .idle
    private var assetWriter: AVAssetWriter?
    private var assetWriterVideoInput: AVAssetWriterInput?
    
    override init() {
        super.init()
        checkPermission()
        configureSession()
        outputCameraSession()
        
        DispatchQueue.global().async {
            self.session.startRunning()
        }
    }
    
    func startRecord() {
        captureStatus = .start
    }
    
    func stopRecord() {
        captureStatus = .end
    }
    
    func changeUseCamera() {
        guard let currentCameraInput = session.inputs.first else { return }
        
        session.removeInput(currentCameraInput)
        
        if (currentCameraInput as? AVCaptureDeviceInput)?.device.position == .back {
            guard let newCamera = cameraWithPosition(.front) else { return }
            try? session.addInput(AVCaptureDeviceInput(device: newCamera))
        } else {
            guard let newCamera = cameraWithPosition(.back) else { return }
            try? session.addInput(AVCaptureDeviceInput(device: newCamera))
        }
    }
    
    private func cameraWithPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let deviceDescoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)

        for device in deviceDescoverySession.devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isCameraPermission = true
        case .notDetermined:
            requestCameraPermission()
        default:
            isCameraPermission = false
        }
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            self?.isCameraPermission = granted
        }
    }
    
    private func configureSession() {
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            return
        }
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            return
        }
        
        session.addInput(videoDeviceInput)
        self.videoDeviceInput = videoDeviceInput
    }
    
    private func outputCameraSession() {
        let output = AVCaptureVideoDataOutput()
        
        output.setSampleBufferDelegate(self, queue: DispatchQueue.global())
        
        guard session.canAddOutput(output) else { return }
        
        session.sessionPreset = .hd4K3840x2160
        session.addOutput(output)
        session.commitConfiguration()
        
        self.videoOutput = output
    }
    
    private func configureStoringVideo(sampleBuffer: CMSampleBuffer) {
        fileName = Date().description + videoType
        fileURL = LocalFileURLs.receiveVideoURL(by: fileName)  // will Deprecate
        
        do {
            assetWriter = try AVAssetWriter(outputURL: fileURL!, fileType: .mov)
        } catch {
            print("Create Video Error")
            return
        }
        
        assetWriterVideoInput = AVAssetWriterInput(mediaType: .video, outputSettings: nil)
        assetWriterVideoInput?.expectsMediaDataInRealTime = true
        assetWriter?.add(assetWriterVideoInput!)
        
        assetWriter?.startWriting()
        assetWriter?.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
        
        captureStatus = .recording
    }
    
    private func saveRecordingVideo() {
        assetWriterVideoInput?.markAsFinished()
        assetWriter?.finishWriting() {
            
        }
        assetWriter = nil
        assetWriterVideoInput = nil
        
        captureStatus = .idle
    }
}

extension CameraUseCase: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        switch captureStatus {
        case .start:
            configureStoringVideo(sampleBuffer: sampleBuffer)
        case .recording:
            if output == output, assetWriterVideoInput?.isReadyForMoreMediaData == true {
                assetWriterVideoInput?.append(sampleBuffer)
            }
        case .end:
            saveRecordingVideo()
        default:
            return
        }
    }
}
