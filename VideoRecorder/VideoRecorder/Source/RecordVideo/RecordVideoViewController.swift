//
//  RecordVideoViewController.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/05.
//

import UIKit
import AVFoundation

final class RecordVideoViewController: UIViewController {
    private let captureSession =  {
        let captureSession = AVCaptureSession()

        captureSession.sessionPreset = .high

        return captureSession
    }()

    private lazy var previewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: captureSession)

        layer.bounds = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        layer.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        layer.videoGravity = .resizeAspectFill

        return layer
    }()
    
    private let viewModel: RecordVideoViewModel
    private let recordControlView: RecordControlView
    
    init() {
        viewModel = RecordVideoViewModel()
        recordControlView = RecordControlView(recordVideoViewModel: viewModel)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        layout()
        setUpCaptureSession()
        startCaptureSession()
    }
    
    private func setupView() {
        view.layer.addSublayer(previewLayer)
        view.addSubview(recordControlView)
    }
    
    private func layout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            recordControlView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 40),
            recordControlView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -40),
            recordControlView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -20)
        ])
    }
    
    private func setUpCaptureSession() {
        do {
            captureSession.beginConfiguration()
            
            guard let videoDevice = AVCaptureDevice.default(for: .video) else { return }
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }

            let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)!
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if captureSession.canAddInput(audioInput) {
              captureSession.addInput(audioInput)
            }

            let videoOutput = AVCaptureMovieFileOutput()
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            
            captureSession.commitConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func startCaptureSession() {
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }
}

extension RecordVideoViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("photoOutput")
        guard let imageData = photo.fileDataRepresentation() else {
            print("imageData Error")
            return}
        let outputImage = UIImage(data: imageData)
        
        // globalQueue 에서 Session stop
        DispatchQueue.global().async {
            self.captureSession.stopRunning()
        }
        
        //self.cameraView.layer.removeFromSuperlayer()
        print("cameraView to outputImage")
        view.layer.contents = outputImage
    }
}
