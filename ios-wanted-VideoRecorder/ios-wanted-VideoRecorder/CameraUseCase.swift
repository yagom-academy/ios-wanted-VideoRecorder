//
//  CameraUseCase.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/06.
//

import Foundation
import AVFoundation
import UIKit
import SwiftUI

final class CameraUseCase {
    
    let session = AVCaptureSession()
    var isCameraPermission = false
    
    init() {
        checkPermission()
        configureSession()
        outputCameraSession()
        
        DispatchQueue.global().async {
            self.session.startRunning()
        }
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
        guard let videoDevice = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) else {
            return
        }
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              session.canAddInput(videoDeviceInput) else {
            return
        }
        
        session.addInput(videoDeviceInput)
    }
    
    private func outputCameraSession() {
        let output = AVCapturePhotoOutput()
        
        guard session.canAddOutput(output) else { return }
        
        session.sessionPreset = .hd4K3840x2160
        session.addOutput(output)
        session.commitConfiguration()
    }
}
