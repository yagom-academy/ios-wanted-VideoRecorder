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
    private var dbManager: DBUseCase = LocalDBUseCase<VideoObject>()
    private var cameraManager: CameraUseCase = DefaultCameraUseCase()
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
                startRecord()
            } else {
                stopRecord()
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
    
    private func startRecord() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.second += 1
        })
        
        cameraManager.startRecord()
    }
    
    private func stopRecord() {
        let minute = self.minute
        let second = self.second
        
        resetTimer()
        cameraManager.stopRecord()
        
        guard let url = cameraManager.fileURL else { return }
        let title = cameraManager.fileName
        let video = Video(title: title,
              date: Date(),
              videoURL: url,
              videoLength: String(format: "%02d:%02d", minute, second))
        guard let videoObject = Video.toRealmObject(video) as? VideoObject else { return }
        
        dbManager.create(videoObject)
    }
    
    private func resetTimer() {
        self.timer?.invalidate()
        self.timer = nil
        minute = 0
        second = 0
    }
}
