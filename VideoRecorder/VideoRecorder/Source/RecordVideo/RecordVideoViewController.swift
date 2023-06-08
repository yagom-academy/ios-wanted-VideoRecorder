//
//  RecordVideoViewController.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/05.
//

import UIKit
import AVFoundation

final class RecordVideoViewController: UIViewController {
    private lazy var previewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: viewModel.recorderCaptureSession)

        layer.bounds = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        layer.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        layer.videoGravity = .resizeAspectFill

        return layer
    }()

    private let viewModel: RecordVideoViewModel
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
    
    private func startCaptureSession() {
        viewModel.startCaptureSession()
    }
}
