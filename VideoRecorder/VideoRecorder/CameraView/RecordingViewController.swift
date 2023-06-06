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
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private let swapButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.triangle.2.circlepath.camera"), for: .normal)
        
        return button
    }()
    private let timerLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    private let thumbnailView = UIImageView(frame: CGRect(x: .zero, y: .zero, width: 45, height: 45))
    private let recordButton = RecordingButton()
    
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: self.viewModel.captureSession())

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
    }
    
    private func configureRootView() {
        view.layer.addSublayer(previewLayer)
    }
    
    private func setupViewHierarchy() {
        let recordButtonStackView = UIStackView(arrangedSubviews: [recordButton, timerLabel])
        recordButtonStackView.axis = .vertical
        recordButtonStackView.alignment = .center
        recordButtonStackView.distribution = .equalSpacing
        
        let recordingStackView = UIStackView(arrangedSubviews: [
            thumbnailView, recordButtonStackView, swapButton
        ])
        recordingStackView.axis = .horizontal
        recordingStackView.alignment = .center
        recordingStackView.distribution = .equalSpacing
        
        let opaqueView = UIView()
        opaqueView.alpha = 0.3
        opaqueView.backgroundColor = .black
        opaqueView.addSubview(recordingStackView)
    
        view.addSubview(opaqueView)
        view.addSubview(closeButton)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            
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
            radius: width / 2 - 4,
            startAngle: .zero,
            endAngle: .pi * 2,
            clockwise: true
        )
        outterCirclePath.lineWidth = 4
        UIColor.white.setStroke()
        outterCirclePath.stroke()
        
        let innerCirclePath = UIBezierPath(
            arcCenter: CGPoint(x: width / 2, y: height / 2),
            radius: width / 2 - 13,
            startAngle: .zero,
            endAngle: .pi * 2,
            clockwise: true
        )
        UIColor.systemRed.setFill()
        innerCirclePath.fill()
        
        if self.isSelected { }
    }
}
