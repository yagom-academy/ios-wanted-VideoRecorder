//
//  RecordingVideoViewController.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/08.
//

import UIKit
import AVFoundation

final class RecordingVideoViewController: UIViewController {
    private enum Constant {
        static let ButtonWidth: CGFloat = 35
        static let buttonRadius: CGFloat = 17.5
        static let RecordingButtonWidth: CGFloat = 20
        static let recordingButtonRadius: CGFloat = 0
        static let borderViewWidth: CGFloat = 60
    }
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(
            pointSize: 30, weight: .bold, scale: .default
        )
        button.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let historyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mockImage")
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let recordingButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = Constant.buttonRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let recordingPlayerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 50
        stackView.backgroundColor = .black.withAlphaComponent(0.5)
        stackView.layer.cornerRadius = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let switchCameraButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .default)
        button.setImage(
            UIImage(systemName: "arrow.triangle.2.circlepath.camera", withConfiguration: config),
            for: .normal
        )
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private var isAccessDevice: Bool = false
    private let recordManager = RecordManager()
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview = AVCaptureVideoPreviewLayer(session: recordManager.captureSession)
        preview.bounds = CGRect(
            origin: .zero,
            size: CGSize(width: view.bounds.width, height: view.bounds.height)
        )
        preview.connection?.videoOrientation = .portrait
        preview.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        preview.videoGravity = .resizeAspectFill
        
        return preview
    }()
    
    private var buttonWidthConstraint: NSLayoutConstraint!
    private var buttonHeightConstraint: NSLayoutConstraint!
    
    var timer: Timer?
    var secondsOfTimer = 0
    
    override func viewDidLoad() {
        requestDeviceRight()
        configureLayout()
        connectTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isAccessDevice {
            recordManager.startCaptureSession()
        }
    }
    
    private func requestDeviceRight() {
        var videoRight = false
        var audioRight = false
        AVCaptureDevice.requestAccess(for: .video) { isAccessVideo in
            videoRight = isAccessVideo
        }
        AVCaptureDevice.requestAccess(for: .audio) { isAccessAudio in
            audioRight = isAccessAudio
        }
        
        if videoRight, audioRight {
            isAccessDevice = true
            setupCamera()
        }
    }
    
    private func setupCamera() {
        do {
            try recordManager.setupCamera()
            setupPreview()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupPreview() {
        self.view.layer.addSublayer(previewLayer)
    }
    
    private func configureLayout() {
        view.backgroundColor = .white
        configureDismissButtonLayout()
        configureRecordingPlayerViewLayout()
    }
    
    private func configureDismissButtonLayout() {
        view.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            dismissButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
        ])
    }
    
    private func configureRecordingPlayerViewLayout() {
        view.addSubview(recordingPlayerView)
        
        NSLayoutConstraint.activate([
            recordingPlayerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            recordingPlayerView.heightAnchor.constraint(
                equalTo: recordingPlayerView.widthAnchor,
                multiplier: 0.35
            ),
            recordingPlayerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordingPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
        
        let timerStackView = UIStackView()
        timerStackView.axis = .vertical
        timerStackView.spacing = 0
        timerStackView.alignment = .center
        
        recordingPlayerView.addArrangedSubview(historyImageView)
        recordingPlayerView.addArrangedSubview(timerStackView)
        recordingPlayerView.addArrangedSubview(switchCameraButton)
        
        timerStackView.addArrangedSubview(borderView)
        borderView.addSubview(recordingButton)
        timerStackView.addArrangedSubview(timerLabel)
        
        buttonWidthConstraint = recordingButton.widthAnchor.constraint(equalToConstant: Constant.ButtonWidth)
        buttonHeightConstraint = recordingButton.heightAnchor.constraint(equalToConstant: Constant.ButtonWidth)
        
        NSLayoutConstraint.activate([
            historyImageView.widthAnchor.constraint(equalToConstant: 50),
            historyImageView.heightAnchor.constraint(equalToConstant: 50),
            historyImageView.leadingAnchor.constraint(equalTo: recordingPlayerView.leadingAnchor, constant: 7),
            
            borderView.widthAnchor.constraint(equalToConstant: Constant.borderViewWidth),
            borderView.heightAnchor.constraint(equalToConstant: Constant.borderViewWidth),
            borderView.centerXAnchor.constraint(equalTo: recordingPlayerView.centerXAnchor),
            
            buttonWidthConstraint,
            buttonHeightConstraint,
            recordingButton.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            recordingButton.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
            
            switchCameraButton.widthAnchor.constraint(equalToConstant: 50),
            switchCameraButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func connectTarget() {
        recordingButton.addTarget(self, action: #selector(recordingButtonTapped), for: .touchUpInside)
        switchCameraButton.addTarget(self, action: #selector(switchCameraButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Timer methods
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }
            
            self.secondsOfTimer += 1
            self.timerLabel.text = Double(self.secondsOfTimer).format(units: [.minute, .second])
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        secondsOfTimer = 0
        self.timerLabel.text = "00:00"
    }
    
    @objc
    private func recordingButtonTapped() {
        guard isAccessDevice else { return }
        recordingButton.isSelected.toggle()
        
        recordingButton.isSelected ? self.startTimer() : self.stopTimer()
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
            if self.recordingButton.isSelected {
                self.buttonWidthConstraint.constant = Constant.RecordingButtonWidth
                self.buttonHeightConstraint.constant = Constant.RecordingButtonWidth
                self.recordingButton.layer.cornerRadius = Constant.recordingButtonRadius
            } else {
                self.buttonWidthConstraint.constant = Constant.ButtonWidth
                self.buttonHeightConstraint.constant = Constant.ButtonWidth
                self.recordingButton.layer.cornerRadius = Constant.buttonRadius
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc
    private func switchCameraButtonTapped() {
        guard isAccessDevice else { return }
        recordManager.switchCamera()
    }
}

fileprivate extension Double {
    func format(units: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.zeroFormattingBehavior = [.pad]
        
        return formatter.string(from: self)
    }
}

