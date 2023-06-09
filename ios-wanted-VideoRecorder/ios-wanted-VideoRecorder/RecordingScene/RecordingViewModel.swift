//
//  RecordingViewModel.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/09.
//

import AVFoundation

final class RecordingViewModel {
    private let recordManager: RecordManager
    private var isAccessDevice = false
    
    init(recordManager: RecordManager) {
        self.recordManager = recordManager
    }
    
    func setupDevice() throws {
        let videoPermission = PermissionChecker.checkPermission(about: .video)
        let audioPermission = PermissionChecker.checkPermission(about: .audio)

        if videoPermission {
            isAccessDevice = true
            try recordManager.setupCamera()
        }

        if audioPermission {
            try recordManager.setupAudio(with: audioPermission)
        }
    }
    
    func makePreview(size: CGSize) -> AVCaptureVideoPreviewLayer {
        let preview = recordManager.makePreview(size: size)
        return preview
    }
    
    func startCaptureSession() {
        if isAccessDevice {
            recordManager.startCaptureSession()
        }
    }
}

// MARK: - 디바이스 권한 체커모델
fileprivate struct PermissionChecker {
    static func checkPermission(about device: AVMediaType) -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: device)
        var isAccessVideo = false
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: device) { granted in
                isAccessVideo = granted
            }
        case .authorized:
            return true
        default:
            return false
        }
        
        return isAccessVideo
    }
}
