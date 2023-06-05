//
//  CameraViewModel.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import CoreImage
import Foundation
import AVFoundation

final class CameraViewModel: NSObject, ObservableObject {
    
    private var timer: Timer?
    private var isCameraPermission = false
    private var captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue.global()
    private let context = CIContext()
    
    @Published var cameraFrame: CGImage?
    @Published var isRecord: Bool = false {
        willSet {
            if newValue == true {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    self.second += 1
                }
            } else {
                self.timer?.invalidate()
                self.timer = nil
                minute = 0
                second = 0
            }
        }
    }
    @Published var minute: Int = 0
    @Published var second: Int = 0 {
        didSet {
            if second > 59 {
                minute += 1
                second = 0
            }
        }
    }
    
    override init() {
        super.init()
        checkPermission()
        sessionQueue.async { [weak self] in
            self?.setupCaptureSession()
            self?.captureSession.startRunning()
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    func disconnectCaptureSession() {
        self.isCameraPermission = false
        self.captureSession.stopRunning()
        self.cameraFrame = nil
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isCameraPermission = true
        case .notDetermined:
            requestCameraPermission()
        default:
            isCameraPermission = false
        }
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            self?.isCameraPermission = granted
        }
    }
    
    func setupCaptureSession() {
        let videoOutput = AVCaptureVideoDataOutput()
        
        guard isCameraPermission else { return }
        guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        
        captureSession.addInput(videoDeviceInput)
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global())
        captureSession.addOutput(videoOutput)
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
    }
}

extension CameraViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.cameraFrame = cgImage
        }
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        return cgImage
    }
}
