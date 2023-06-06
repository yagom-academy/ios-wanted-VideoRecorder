//
//  RecordingViewController.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/05.
//

import UIKit
import AVFoundation

final class RecordingViewController: UIViewController {
    private let closeButton = {
        let button = UIButton()
        var image = UIImage(systemName: "xmark.circle.fill")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private let swapButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.triangle.2.circlepath.camera"), for: .normal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        
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
    private let thumbnailView = {
        let imageView = UIImageView()
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    private let recordingStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 30
        
        return stackView
    }()
    private let opaqueView = {
        let opaqueView = UIView()
        opaqueView.backgroundColor = .separator
        opaqueView.layer.cornerRadius = 15
        opaqueView.translatesAutoresizingMaskIntoConstraints = false
        
        return opaqueView
    }()
    
    private let recordButton = RecordingButton()
    
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: viewModel.captureSession())

    private let viewModel: RecordingViewModel
    
    init(viewModel: RecordingViewModel, thumbnailImage: UIImage?) {
        self.viewModel = viewModel
        self.thumbnailView.image = thumbnailImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRootView()
        setupViewHierarchy()
        setupLayoutConstraints()
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
        view.layer.addSublayer(previewLayer)
    }
    
    private func setupViewHierarchy() {
        let recordButtonStackView = UIStackView(arrangedSubviews: [recordButton, timerLabel])
        recordButtonStackView.axis = .vertical
        recordButtonStackView.alignment = .fill
        recordButtonStackView.distribution = .fill
        
        recordingStackView.addArrangedSubview(thumbnailView)
        recordingStackView.addArrangedSubview(recordButtonStackView)
        recordingStackView.addArrangedSubview(swapButton)
        
        opaqueView.addSubview(recordingStackView)
    
        view.addSubview(opaqueView)
        view.addSubview(closeButton)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            thumbnailView.heightAnchor.constraint(equalToConstant: 20),
            thumbnailView.widthAnchor.constraint(equalTo: thumbnailView.heightAnchor, multiplier: 1),
            
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            recordingStackView.topAnchor.constraint(equalTo: opaqueView.topAnchor, constant: 10),
            recordingStackView.bottomAnchor.constraint(equalTo: opaqueView.bottomAnchor, constant: -10),
            recordingStackView.leadingAnchor.constraint(equalTo: opaqueView.leadingAnchor, constant: 20),
            recordingStackView.trailingAnchor.constraint(equalTo: opaqueView.trailingAnchor, constant: -20),
            
            opaqueView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            opaqueView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            opaqueView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            opaqueView.topAnchor.constraint(equalTo: view.topAnchor, constant: 650)
        ])
    }
}

final class RecordingButton: UIButton {
    override func draw(_ rect: CGRect) {
        let width = self.bounds.width
        let height = self.bounds.height
        let centerPoint = CGPoint(x: width / 2, y: height / 2)
        let outterCirclePath = UIBezierPath(
            arcCenter: centerPoint,
            radius: width / 2 - 18,
            startAngle: .zero,
            endAngle: .pi * 2,
            clockwise: true
        )
        outterCirclePath.lineWidth = 4
        UIColor.white.setStroke()
        outterCirclePath.stroke()
        
        let innerCirclePath = UIBezierPath(
            arcCenter: CGPoint(x: width / 2, y: height / 2),
            radius: width / 2 - 25,
            startAngle: .zero,
            endAngle: .pi * 2,
            clockwise: true
        )
        UIColor.systemRed.setFill()
        innerCirclePath.fill()
        
        if self.isSelected { }
    }
}
