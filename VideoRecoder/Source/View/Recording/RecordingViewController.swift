//
//  RecordingViewController.swift
//  VideoRecoder
//
//  Created by kimseongjun on 2023/06/07.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController {
    
    private var outputURL: URL?
    
    private let standardPadding: CGFloat = 20
    private lazy var videoDevice = AVCaptureDevice.default(for: .video)
    private var captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureMovieFileOutput()
    private var previewLayer = AVCaptureVideoPreviewLayer()
    private let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    private let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    
    var timer: Timer?
    var secondsOfTimer = 0
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = UIColor.clear.withAlphaComponent(0.4)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 80), forImageIn: .normal) // weight
        button.addTarget(self, action: #selector(tapCloseButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let recordMenuView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear.withAlphaComponent(0.4)
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray3
        imageView.layer.cornerRadius = 5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let recordingButton: RecordingButton = {
        let button = RecordingButton()
        button.addTarget(self, action: #selector(tapRecordingButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "00:00:00"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let rotatingCameraButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.triangle.2.circlepath.camera"), for: .normal)
        button.tintColor = .white
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 40), forImageIn: .normal)
        button.addTarget(self, action: #selector(tapRotatingCameraButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        configureSession()
        configurePreviewLayer()
        configureUI()
        startSession()
    }
    
    @objc
    private func tapCloseButton() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func tapRecordingButton() {
        recordingButton.isSelected.toggle()
        if recordingButton.isSelected {
            startRecording()
        } else {
            stopRecording()
        }
    }
    
    @objc
    private func tapRotatingCameraButton() {
        captureSession.beginConfiguration()
        
        guard let currentInput = captureSession.inputs.last as? AVCaptureDeviceInput else { return }
        
        captureSession.removeInput(currentInput)
        
        
        guard let newCameraPosition = currentInput.device.position == .back ? camera(with: .front) : camera(with: .back) else { return }

        do {
            let newVideoInput = try AVCaptureDeviceInput(device: newCameraPosition)
            captureSession.addInput(newVideoInput)
        }
        catch {
            print(error)
        }

        captureSession.commitConfiguration()
    }
    
    private func camera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        return devices.filter { $0.position == position }.first
    }
    
    private func configureSession() {
        do {
            captureSession.beginConfiguration()
            
            let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)!
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if captureSession.canAddInput(audioInput) {
                captureSession.addInput(audioInput)
            }
            
            guard let backCamera = self.backCamera else { return }
            let backCameraInput = try AVCaptureDeviceInput(device: backCamera)
            if captureSession.canAddInput(backCameraInput) {
                captureSession.addInput(backCameraInput)
            }
            
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            
            captureSession.commitConfiguration()
        }
        catch {
            print(error)
        }
    }
    
    private func configurePreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.frame = view.frame
        
        view.layer.addSublayer(previewLayer)
    }
    
    private func startSession() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    private func configureUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(recordMenuView)
        view.addSubview(closeButton)
        recordMenuView.addSubview(thumbnailImageView)
        recordMenuView.addSubview(recordingButton)
        recordMenuView.addSubview(timerLabel)
        recordMenuView.addSubview(rotatingCameraButton)
        
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: standardPadding),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardPadding),
            
            recordMenuView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.18),
            recordMenuView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardPadding),
            recordMenuView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardPadding),
            recordMenuView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -standardPadding),
            
            thumbnailImageView.leadingAnchor.constraint(equalTo: recordMenuView.leadingAnchor, constant: standardPadding),
            thumbnailImageView.centerYAnchor.constraint(equalTo: recordMenuView.centerYAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 50),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 50),
            
            recordingButton.heightAnchor.constraint(equalToConstant: 80),
            recordingButton.widthAnchor.constraint(equalToConstant: 80),
            recordingButton.centerXAnchor.constraint(equalTo: recordMenuView.centerXAnchor),
            recordingButton.centerYAnchor.constraint(equalTo: recordMenuView.centerYAnchor),
            
            timerLabel.topAnchor.constraint(equalTo: recordingButton.bottomAnchor, constant: 10),
            timerLabel.centerXAnchor.constraint(equalTo: recordMenuView.centerXAnchor),
            
            rotatingCameraButton.trailingAnchor.constraint(equalTo: recordMenuView.trailingAnchor, constant: -standardPadding),
            rotatingCameraButton.centerYAnchor.constraint(equalTo: recordMenuView.centerYAnchor)
        ])
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            self.secondsOfTimer += 1
            self.timerLabel.text = Double(self.secondsOfTimer).format(units: [.hour , .minute, .second])
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        self.timerLabel.text = "00:00:00"
        self.secondsOfTimer = 0
    }
}

extension RecordingViewController: AVCaptureFileOutputRecordingDelegate {
    private func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
    
    private func startRecording() {
        outputURL = tempURL()
        videoOutput.startRecording(to: outputURL!, recordingDelegate: self)
    }
    
    private func stopRecording() {
        if videoOutput.isRecording {
            videoOutput.stopRecording()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        startTimer()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if (error != nil) {
            print("Error recording movie: \(error!.localizedDescription)")
        } else {
            stopTimer()
            let videoRecorded = outputURL! as URL
            UISaveVideoAtPathToSavedPhotosAlbum(videoRecorded.path, nil, nil, nil)
        }
    }
}


