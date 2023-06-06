//
//  CameraViewModel.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import SwiftUI
import AVFoundation

final class CameraViewModel: NSObject, ObservableObject {
    
    private var timer: Timer?
    var cameraManager = CameraUseCase()
    var isCameraPermission: Bool {
        return cameraManager.isCameraPermission
    }
    var cameraSession: AVCaptureSession {
        return cameraManager.session
    }
    
    @Published var isCameraFronted = false {
        willSet {
            cameraManager.changeUseCamera()
        }
    }
    @Published var isRecord: Bool = false {
        willSet {
            if newValue == true {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    self.second += 1
                }
                cameraManager.startRecord()
            } else {
                self.timer?.invalidate()
                self.timer = nil
                minute = 0
                second = 0
                cameraManager.stopRecord()
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
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}
