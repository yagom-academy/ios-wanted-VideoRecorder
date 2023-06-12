//
//  CameraUseCase.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/09.
//

import Foundation
import AVFoundation

protocol CameraUseCase {
    
    var fileURL: URL? { get set }
    var fileName: String { get set }
    var session: AVCaptureSession { get set }
    var isCameraPermission: Bool { get set }
    
    func startRecord()
    
    func stopRecord()
    
    func changeUseCamera()
    
    func checkPermission()
}
