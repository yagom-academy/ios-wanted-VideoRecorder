//
//  RecordingViewController.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/05.
//

import UIKit
import AVFoundation
import Combine


final class RecordingViewController: UIViewController {
    private let closeButton = {
        let button = UIButton()
        var image = UIImage(systemName: "xmark.circle.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private let swapButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.triangle.2.circlepath.camera"), for: .normal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.tintColor = .white
        
        return button
    }()
    private let timerLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.text = "00:00"
        label.setContentHuggingPriority(.required, for: .vertical)
        
        return label
    }()
    private let thumbnailButton = {
        let button = UIButton()
        button.setContentHuggingPriority(.required, for: .horizontal)
        
        return button
    }()
    private let recordingStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 70
        
        return stackView
    }()
    private let opaqueView = {
        let opaqueView = UIView()
        opaqueView.backgroundColor = .separator
        opaqueView.layer.cornerRadius = 15
        opaqueView.translatesAutoresizingMaskIntoConstraints = false
        
        return opaqueView
    }()
    private lazy var previewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.viewModel.captureSession())
        layer.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        layer.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        layer.videoGravity = .resizeAspectFill
        
        return layer
    }()
    private let recordButton = RecordingButton()

    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: RecordingViewModel
    
    init(viewModel: RecordingViewModel, thumbnailImage: UIImage?) {
        self.viewModel = viewModel
        self.thumbnailButton.setImage(thumbnailImage, for: .normal)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRootView()
        configureCaptureSession()
        setupViewHierarchy()
        setupLayoutConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.runCaptureSession()
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
        view.layer.addSublayer(previewLayer)
    }
    
    private func configureCaptureSession() {
        do {
            try viewModel.configureSession()
        } catch {
            print(error)
        }
    }
    
    private func setupViewHierarchy() {
        let recordButtonStackView = UIStackView(arrangedSubviews: [recordButton, timerLabel])
        recordButtonStackView.axis = .vertical
        recordButtonStackView.alignment = .fill
        recordButtonStackView.distribution = .fill
        
        recordingStackView.addArrangedSubview(thumbnailButton)
        recordingStackView.addArrangedSubview(recordButtonStackView)
        recordingStackView.addArrangedSubview(swapButton)
        
        opaqueView.addSubview(recordingStackView)
    
        view.addSubview(opaqueView)
        view.addSubview(closeButton)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            recordingStackView.topAnchor.constraint(equalTo: opaqueView.topAnchor, constant: 20),
            recordingStackView.bottomAnchor.constraint(equalTo: opaqueView.bottomAnchor, constant: -20),
            recordingStackView.leadingAnchor.constraint(equalTo: opaqueView.leadingAnchor, constant: 20),
            recordingStackView.trailingAnchor.constraint(equalTo: opaqueView.trailingAnchor, constant: -20),
            
            opaqueView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            opaqueView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            opaqueView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            opaqueView.topAnchor.constraint(equalTo: view.topAnchor, constant: 650)
        ])
    }

    private func bindAction() {
        let recordButtonPublisher = recordButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
        
        let input = RecordingViewModel.Input(recordButtonPublisher: recordButtonPublisher)
        
        let output = viewModel.transform(input: input)
        
        output.recordingError
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: {
                print("Recording process excuted")
            })
            .store(in: &cancellables)
    }
    
}

private final class RecordingButton: UIButton {
    override func draw(_ rect: CGRect) {
        let width = self.bounds.width
        let height = self.bounds.height
        let radius = min(width, height)
        let centerPoint = CGPoint(x: width / 2, y: height / 2)
        let outterCirclePath = UIBezierPath(
            arcCenter: centerPoint,
            radius: radius / 2 - 4,
            startAngle: .zero,
            endAngle: .pi * 2,
            clockwise: true
        )
        outterCirclePath.lineWidth = 4
        UIColor.white.setStroke()
        outterCirclePath.stroke()
        
        let innerCirclePath = UIBezierPath(
            arcCenter: CGPoint(x: width / 2, y: height / 2),
            radius: radius / 2 - 12,
            startAngle: .zero,
            endAngle: .pi * 2,
            clockwise: true
        )
        UIColor.systemRed.setFill()
        innerCirclePath.fill()
        
        if self.isSelected { }
    }
}
