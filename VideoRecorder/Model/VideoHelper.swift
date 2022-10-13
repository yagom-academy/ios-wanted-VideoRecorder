//
//  VideoHelper.swift
//  VideoRecorder
//
//  Created by sole on 2022/10/13.
//

import UIKit
import UniformTypeIdentifiers

enum VideoHelper {
    static func startRecording(delegate: UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera UnAvailable")
            return
        }
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = .camera
        mediaUI.mediaTypes = [UTType.movie.identifier]
        mediaUI.allowsEditing = false
        mediaUI.delegate = delegate
        delegate.present(mediaUI, animated: true)
    }
}
