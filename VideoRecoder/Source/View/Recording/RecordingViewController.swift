//
//  RecordingViewController.swift
//  VideoRecoder
//
//  Created by kimseongjun on 2023/06/07.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController {
    private let standardPadding: CGFloat = 20
    private lazy var captureDevice = AVCaptureDevice.default(for: .video)
    private var session: AVCaptureSession?
    private var output = AVCapturePhotoOutput()
    private var previewLayer = AVCaptureVideoPreviewLayer()
    
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
    
    private let recordingButton: RecordingButton = {
        let button = RecordingButton()
        button.addTarget(self, action: #selector(tapRecordingButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        settingCamera()
        configureUI()
    }
    
    @objc
    private func tapCloseButton() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func tapRecordingButton() {
        recordingButton.isSelected.toggle()
    }
    
    func settingCamera() {
        guard let captureDevice = captureDevice else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session = AVCaptureSession()
            session?.sessionPreset = .hd1920x1080
            session?.addInput(input)
            session?.addOutput(output)
        } catch {
            print(error)
        }
        
        guard let session = session else { return }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.frame
        
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }
    
    func configureUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(recordMenuView)
        view.addSubview(closeButton)
        recordMenuView.addSubview(recordingButton)
        
        NSLayoutConstraint.activate([
            recordMenuView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.2),
            recordMenuView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardPadding),
            recordMenuView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardPadding),
            recordMenuView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -standardPadding),
            
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: standardPadding),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardPadding),
            
            recordingButton.heightAnchor.constraint(equalToConstant: 80),
            recordingButton.widthAnchor.constraint(equalToConstant: 80),
            recordingButton.centerXAnchor.constraint(equalTo: recordMenuView.centerXAnchor),
            recordingButton.centerYAnchor.constraint(equalTo: recordMenuView.centerYAnchor)
        ])
    }
}


class RecordingButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        guard let myContext = UIGraphicsGetCurrentContext() else { return }
        
        let height = bounds.height
        let width = bounds.width
        let whiteCircleFrame = bounds.insetBy(dx: width * 0.05, dy: height * 0.05)
        let redCircleFrame = bounds.insetBy(dx: width * 0.15, dy: height * 0.15)
        
        if isSelected {
            myContext.setStrokeColor(UIColor.white.cgColor)
            myContext.setLineWidth(5)
            myContext.addEllipse(in: whiteCircleFrame)
            myContext.drawPath(using: .stroke)
            myContext.closePath()
            
            myContext.setFillColor(UIColor.red.cgColor)
            myContext.addRect(CGRect(x: width * 0.3, y: height * 0.3, width: width * 0.4, height: height * 0.4))
            myContext.drawPath(using: .fill)
            myContext.closePath()
        } else {
            myContext.setStrokeColor(UIColor.white.cgColor)
            myContext.setLineWidth(5)
            myContext.addEllipse(in: whiteCircleFrame)
            myContext.drawPath(using: .stroke)
            myContext.closePath()
            
            myContext.setFillColor(UIColor.red.cgColor)
            myContext.addEllipse(in: redCircleFrame)
            myContext.drawPath(using: .fill)
            myContext.closePath()
        }
    }
}
