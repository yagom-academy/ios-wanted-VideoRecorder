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
    
    private lazy var fileName = "\(Date().translateTimeFormat()).mp4"
    private lazy var duration: TimeInterval = 0
    private var recordingTimer: Timer?
    private var recordingStartTime: Date?
    
    private let thumbnailIButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.setImage(UIImage(named: "sample"), for: .normal)
        return button
    }()
    
    private let shutterButton = ShutterButton()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "00:00"
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    private let cameraSwitchingButton: UIButton = {
        let button = UIButton()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular)
        let image = UIImage(systemName: SystemImageName.cameraSwitching, withConfiguration: symbolConfiguration)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.white)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let cameraToolView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIOption()
        configureLayout()
        checkCameraPermissions()
    }
    
    private func configureUIOption() {
        view.backgroundColor = .white
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
        shutterButton.addTarget(self, action: #selector(didTapShutterButton), for: .touchUpInside)
    }
    
    @objc private func popAddVideoViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    private func createCameraToolStackView() -> UIStackView {
        let shutterButtonStackView = UIStackView(arrangedSubviews: [shutterButton, timerLabel])
        shutterButtonStackView.axis = .vertical
        shutterButtonStackView.distribution = .fill
        shutterButtonStackView.alignment = .fill
        shutterButtonStackView.spacing = 8
        
        let cameraToolStackView = UIStackView(arrangedSubviews: [thumbnailIButton, shutterButtonStackView, cameraSwitchingButton])
        cameraToolStackView.translatesAutoresizingMaskIntoConstraints = false
        cameraToolStackView.axis = .horizontal
        cameraToolStackView.distribution = .equalSpacing
        cameraToolStackView.alignment = .center
        return cameraToolStackView
    }
    
    private func configureLayout() {
        let stackView = createCameraToolStackView()
        
        view.addSubview(cameraToolView)
        cameraToolView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            cameraToolView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/6),
            cameraToolView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cameraToolView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cameraToolView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            shutterButton.widthAnchor.constraint(equalToConstant: 56),
            shutterButton.heightAnchor.constraint(equalTo: shutterButton.widthAnchor),
            
            thumbnailIButton.widthAnchor.constraint(equalToConstant: 56),
            thumbnailIButton.heightAnchor.constraint(equalTo: thumbnailIButton.widthAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: cameraToolView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: cameraToolView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: cameraToolView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: cameraToolView.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - Camera function

extension AddVideoViewController {
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted else { return }
                
                DispatchQueue.main.async { [weak self] in
                    self?.session?.startRunning()
                    self?.setUpCamera()
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
        session = AVCaptureSession()
        guard let session = session else { return }
        
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

    @objc private func didTapShutterButton(_ sender: ShutterButton) {
        guard session != nil else { return }
        
        if movieOutput.isRecording {
            sender.isSelected = false
            movieOutput.stopRecording()
            stopRecordingTimer()
        } else {
            sender.isSelected = true
            let outputPath = NSTemporaryDirectory() + fileName
            let outputURL = URL(fileURLWithPath: outputPath)
            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
            startRecordingTimer()
        }
    }

    private func startRecordingTimer() {
        recordingStartTime = Date()
        recordingTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                              target: self,
                                              selector: #selector(updateRecordingTimer),
                                              userInfo: nil,
                                              repeats: true)
    }
    
    private func stopRecordingTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
        timerLabel.text = "00:00"
    }
    
    @objc private func updateRecordingTimer() {
        guard let startTime = recordingStartTime else { return }
        
        let currentTime = Date()
        let elapsedSeconds = currentTime.timeIntervalSince(startTime)
        let formattedTime = elapsedSeconds.formatTime()
        
        duration = elapsedSeconds
        timerLabel.text = formattedTime
    }
}

// MARK: - AVCapture File Output Recording Delegate

extension AddVideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error {
            print("Recording error: \(error)")
        } else {
            guard let thumbnailImage = generateThumbnailImage(from: outputFileURL) else { return }
            saveVideoToDocumentDirectory(id: UUID(), url: outputFileURL, thumbnail: thumbnailImage)
            thumbnailIButton.setImage(thumbnailImage, for: .normal)
        }
    }
    
    private func saveVideoToDocumentDirectory(id: UUID, url: URL, thumbnail: UIImage) {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                 in: .userDomainMask).first
        
        guard let destinationURL = documentDirectory?.appendingPathComponent(id.uuidString) else {
            print("Failed to create destination URL")
            return
        }
        
        do {
            print(destinationURL)
            try fileManager.moveItem(at: url, to: destinationURL)
            createVideo(id: id, url: destinationURL, thumbnail: thumbnail)
        } catch {
            print("Failed to save documents directory")
        }
    }
    
    private func generateThumbnailImage(from url: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            let time = CMTime(seconds: 0.0, preferredTimescale: 1)
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch {
            print("Failed to create Thumbnail Image: \(error)")
            return nil
        }
    }
}

// MARK: - Core data

extension AddVideoViewController {
    private func createVideo(id: UUID, url: URL, thumbnail: UIImage) {
        guard let thumbnailData = thumbnail.pngData() else {
            print("Failed to convert thumbnail image to Data")
            return
        }
        
        let videoInfo = VideoInfo(id: id,
                                  videoURL: url,
                                  thumbnailImage: thumbnailData,
                                  duration: duration,
                                  fileName: fileName,
                                  registrationDate: Date())
        
        CoreDataManager.shared.create(videoInfo: videoInfo)
        duration = 0
    }
}
