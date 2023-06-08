//
//  RecordVideoViewController.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/05.
//

import UIKit
import Combine
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
    
    private var camera: AVCaptureDevice?
    private let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInUltraWideCamera, .builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera], mediaType: .video, position: .unspecified)
    private let videoOutput = AVCaptureMovieFileOutput()
    
    private let viewModel: RecordVideoViewModel
    private var subscriptions = Set<AnyCancellable>()
    
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
        setupNavigationItems()
        bind()
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
    
    private func setupNavigationItems() {
        setupLeftBarButton()
        setupRightBarButton()
    }
    
    private func setupLeftBarButton() {
        navigationItem.hidesBackButton = true
    }
    
    private func setupRightBarButton() {
        let systemImageName = "xmark.circle.fill"
        
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 40)
        let cancelImage = UIImage(systemName: systemImageName, withConfiguration: imageConfiguration)
        
        let cancelButton = UIButton()
        cancelButton.addTarget(self, action: #selector(dismissRecordView), for: .touchUpInside)
        cancelButton.setImage(cancelImage, for: .normal)
        cancelButton.tintColor = .black.withAlphaComponent(0.5)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
    
    @objc private func dismissRecordView() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpCaptureSession() {
        do {
            captureSession.beginConfiguration()
            
            guard let camera else { return }
            
            let videoInput = try AVCaptureDeviceInput(device: camera)
            
            captureSession.inputs.forEach {
                captureSession.removeInput($0)
            }
            
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }

            guard let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio) else { return }

            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if captureSession.canAddInput(audioInput) {
              captureSession.addInput(audioInput)
            }

            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            
            captureSession.commitConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func startCaptureSession() {
        DispatchQueue.global().async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    private func createURL() -> URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let timestamp = Date().timeIntervalSince1970
        let identifier = UUID().uuidString
        let fileName = "recordedVideo_\(timestamp)_\(identifier).mp4"
        let outputURL = documentsDirectory?.appendingPathComponent(fileName)
        
        return outputURL
    }
    
    private func startRecording() {
        guard let url = createURL() else { return }
        
        videoOutput.startRecording(to: url, recordingDelegate: self)
    }
    
    private func stopRecording() {
        if videoOutput.isRecording {
            videoOutput.stopRecording()
        }
    }
}

// MARK: - Bind to viewModel
extension RecordVideoViewController {
    private func bind() {
        rotateCamera()
        recordVideo()
    }
    
    private func rotateCamera() {
        viewModel.$isRotateButtonTapped
            .sink { [weak self] isRotated in
                if isRotated {
                    self?.camera = self?.discoverySession.devices.first { device in
                        device.position == .front
                    }
                } else {
                    self?.camera = self?.discoverySession.devices.first { device in
                        device.position == .back
                    }
                }
                
                self?.setUpCaptureSession()
            }
            .store(in: &subscriptions)
    }
    
    private func recordVideo() {
        viewModel.$isRecordButtonTapped
            .sink { [weak self] isRecordButtonTapped in
                if isRecordButtonTapped {
                    self?.startRecording()
                } else {
                    self?.stopRecording()
                }
            }
            .store(in: &subscriptions)
    }
}

extension RecordVideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("fileOutput")
    }
}
