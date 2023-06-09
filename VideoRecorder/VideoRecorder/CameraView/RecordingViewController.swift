//
//  RecordingViewController.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/05.
//

import UIKit
import Combine

final class RecordingViewController: UIViewController {
    private let closeButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private let switchCameraButton = {
        let button = UIButton()
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "arrow.triangle.2.circlepath.camera", withConfiguration: imageConfiguration)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
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
        button.imageView?.layer.cornerRadius = 10
        button.imageView?.contentMode = .scaleAspectFill
        button.imageEdgeInsets = UIEdgeInsets(top: 22, left: 5, bottom: 22, right: 5)
        button.imageView?.clipsToBounds = true
        button.setContentHuggingPriority(.required, for: .horizontal)
        
        return button
    }()
    private let recordingStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let opaqueView = {
        let opaqueView = UIView()
        opaqueView.layer.backgroundColor = UIColor.clear .withAlphaComponent(0.4).cgColor
        opaqueView.layer.cornerRadius = 15
        opaqueView.translatesAutoresizingMaskIntoConstraints = false
        
        return opaqueView
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
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startCaptureSession()
    }
    
    private func configureRootView() {
        let previewLayer = viewModel.previewLayer()
        previewLayer.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        previewLayer.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        
        self.view.layer.addSublayer(previewLayer)
        self.view.backgroundColor = .systemBackground
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
        recordingStackView.addArrangedSubview(switchCameraButton)
        
        opaqueView.addSubview(recordingStackView)
    
        self.view.addSubview(opaqueView)
        self.view.addSubview(closeButton)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60),
            closeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            thumbnailButton.widthAnchor.constraint(equalTo: recordingStackView.widthAnchor, multiplier: 0.18),
            recordButton.widthAnchor.constraint(equalTo: recordingStackView.widthAnchor, multiplier: 0.25),
            switchCameraButton.widthAnchor.constraint(equalTo: recordingStackView.widthAnchor, multiplier: 0.18),
            
            recordingStackView.topAnchor.constraint(equalTo: opaqueView.topAnchor, constant: 20),
            recordingStackView.bottomAnchor.constraint(equalTo: opaqueView.bottomAnchor, constant: -20),
            recordingStackView.leadingAnchor.constraint(equalTo: opaqueView.leadingAnchor, constant: 20),
            recordingStackView.trailingAnchor.constraint(equalTo: opaqueView.trailingAnchor, constant: -20),
            
            opaqueView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            opaqueView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            opaqueView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -70),
            opaqueView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.15)
        ])
    }

    private func bindAction() {
        let recordButtonTapped = recordButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
        let switchCameraButtonTapped = switchCameraButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
        let closeButtonTapped = closeButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
        
        let input = RecordingViewModel.Input(
            recordButtonTapped: recordButtonTapped,
            switchCameraButtonTapped: switchCameraButtonTapped,
            closeButtonTapped: closeButtonTapped
        )
        
        let output = viewModel.transform(input: input)
        
        output.recordingError
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: {
                print("Recording process excuted")
            })
            .store(in: &cancellables)
        output.switchingError
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: {
                print("Camera position switched")
            })
            .store(in: &cancellables)
        output.isDismissNeeded
            .sink { isDismissNeeded in
                if isDismissNeeded {
                    self.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - RecordingButton
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
