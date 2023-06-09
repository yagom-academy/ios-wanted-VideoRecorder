//
//  RecordingVideoViewController.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/08.
//

import UIKit
import AVFoundation
import Combine

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
        stackView.backgroundColor = .black.withAlphaComponent(0.5)
        stackView.layer.cornerRadius = 10
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
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
    
    private var buttonWidthConstraint: NSLayoutConstraint!
    private var buttonHeightConstraint: NSLayoutConstraint!
    
    var timer: Timer?
    var secondsOfTimer = 0
    let viewModel: RecordingViewModel
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        setupDevice()
        setupPreview()
        configureLayout()
        connectTarget()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.startCaptureSession()
    }
    
    init(recordingViewModel: RecordingViewModel) {
        self.viewModel = recordingViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDevice() {
        do {
            try viewModel.setupDevice()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupPreview() {
        let previewLayer = viewModel.makePreview(size: CGSize(width: view.frame.width, height: view.frame.height))
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
            
            borderView.widthAnchor.constraint(equalToConstant: Constant.borderViewWidth),
            borderView.heightAnchor.constraint(equalToConstant: Constant.borderViewWidth),
            
            buttonWidthConstraint,
            buttonHeightConstraint,
            recordingButton.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            recordingButton.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
            
            switchCameraButton.widthAnchor.constraint(equalToConstant: 50),
            switchCameraButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func connectTarget() {
        switchCameraButton.addTarget(self, action: #selector(switchCameraButtonTapped), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    private func bindUI() {
        let input = RecordingViewModel.Input(
            recordingButtonTappedEvent: recordingButton.buttonPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.isRecording
            .sink { [weak self] isRecording in
                guard let self, let isRecording else { return }
                isRecording ? self.stopTimer() : self.startTimer()
                changeRecordingButtonAppearance(with: isRecording)
            }
            .store(in: &cancellables)
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
    
    private func changeRecordingButtonAppearance(with isRecording: Bool) {
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
            if !isRecording {
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
    
    @objc
    private func dismissButtonTapped() {
        self.dismiss(animated: true)
    }
}

// MARK: - Timer 레이블 DateComponentsFormatter
fileprivate extension Double {
    func format(units: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.zeroFormattingBehavior = [.pad]
        
        return formatter.string(from: self)
    }
}

