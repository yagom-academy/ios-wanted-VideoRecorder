//
//  RecordVideoViewController.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/05.
//

import UIKit

final class RecordVideoViewController: UIViewController {
    private let imagePickerController = {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .camera
        imagePickerController.cameraDevice = .rear
        imagePickerController.mediaTypes = ["public.movie"]
        imagePickerController.cameraCaptureMode = .video
        
        return imagePickerController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        startRecording()
    }
    
    private func setupDelegate() {
        imagePickerController.delegate = self
    }
    
    private func startRecording() {
        present(imagePickerController, animated: true)
    }
}

extension RecordVideoViewController: UIImagePickerControllerDelegate {
    
}

extension RecordVideoViewController: UINavigationControllerDelegate {
    
}
