//
//  PreviewView.swift
//  VideoRecorder
//
//  Created by Subin Kim on 2022/10/12.
//

import UIKit
import AVFoundation

class PreviewView: UIView {

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
           return layer as! AVCaptureVideoPreviewLayer
       }

    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }

}
