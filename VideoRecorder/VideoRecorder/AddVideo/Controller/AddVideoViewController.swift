//
//  AddVideoViewController.swift
//  VideoRecorder
//
//  Created by Hyejeong Jeong on 2023/06/07.
//

import AVFoundation
import UIKit

final class AddVideoViewController: UIViewController {
    var session: AVCaptureSession?
    let movieOutput = AVCaptureMovieFileOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    private let shutterButton: UIButton = {
        let button = ShutterButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIOption()
        checkCameraPermissions()
    }
    
    private func configureUIOption() {
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        
        let rightBarButtonIcon = UIImage(systemName: SystemImageName.xmark)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.systemGray2)
        
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarButtonIcon,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(popAddVideoViewController))
        
        previewLayer.frame = view.bounds
        shutterButton.center = CGPoint(x: view.frame.size.width / 2,
                                       y: view.frame.size.height - 200)
        shutterButton.addTarget(self, action: #selector(didTapShutterButton), for: .touchUpInside)
    }
    
    @objc private func popAddVideoViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted else { return }

                DispatchQueue.main.async { [weak self] in
                    self?.session?.startRunning()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    private func setUpCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(movieOutput) {
                    session.addOutput(movieOutput)
                }
                
                DispatchQueue.global().async { [weak self] in
                    self?.previewLayer.videoGravity = .resizeAspectFill
                    self?.previewLayer.session = session
                    self?.session = session
                    self?.session?.startRunning()
                }
            } catch {
                print(error)
            }
        }
    }

    @objc private func didTapShutterButton() {
        guard session != nil else { return }
        
        if movieOutput.isRecording {
            movieOutput.stopRecording()
        } else {
            let outputPath = NSTemporaryDirectory() + "output.mp4"
            let outputURL = URL(fileURLWithPath: outputPath)
            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
        }
    }
}

// MARK: - AVCapture File Output Recording Delegate

extension AddVideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("녹화 시작")
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("녹화 완료")
    }
}
