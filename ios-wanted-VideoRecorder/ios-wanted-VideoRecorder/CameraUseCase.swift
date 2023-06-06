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
    private var videoDeviceInput: AVCaptureDeviceInput?
    
    init() {
        checkPermission()
        configureSession()
        outputCameraSession()
        
        DispatchQueue.global().async {
            self.session.startRunning()
        }
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
    
    func cameraWithPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
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
        let output = AVCapturePhotoOutput()
        
        guard session.canAddOutput(output) else { return }
        
        session.sessionPreset = .hd4K3840x2160
        session.addOutput(output)
        session.commitConfiguration()
    }
}
