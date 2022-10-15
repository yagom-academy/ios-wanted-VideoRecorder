//
//  CameraViewController.swift
//  VideoRecorder
//
//  Created by 신병기 on 2022/10/11.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    static var identifier: String { String(describing: self) }

    @IBOutlet weak var previewView: PreviewView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var thumbnailButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var switchButton: UIButton!
    
    let captureSession = AVCaptureSession()
    var videoOutput: AVCaptureMovieFileOutput?
    var currentPosition: AVCaptureDevice.Position = .unspecified
    var timer: Timer?
    
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        setupCaptureSession()
        setupUI()
    }
    
    func setupUI() {
        self.controlView.layer.cornerRadius = 25
        
        [closeButton, thumbnailButton, recordButton, switchButton].forEach {
            $0?.addTarget(self, action: #selector(didTapButtonHandler(_:)), for: .touchUpInside)
        }
        
        self.previewView.videoPreviewLayer.session = self.captureSession
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    func setTimerLabel(minutes: String = "00", seconds: String = "00") {
        self.timerLabel.text = "\(minutes):\(seconds)"
    }
    
    // 비디오 인풋과 아웃풋 설정
    func setupCaptureSession() {
        self.captureSession.sessionPreset = .high
        self.captureSession.beginConfiguration()
        
        let videoDevice = getVideoDevice()
        guard let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              self.captureSession.canAddInput(videoInput) else { return }
        self.captureSession.addInput(videoInput)
        
        self.videoOutput = AVCaptureMovieFileOutput()
        guard let videoOutput = self.videoOutput else { return }
        guard self.captureSession.canAddOutput(videoOutput) else { return }
        self.captureSession.addOutput(videoOutput)
        
        guard let microphone = AVCaptureDevice.default(for: .audio) else { return }
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone),
              self.captureSession.canAddInput(audioInput) else { return }
        self.captureSession.addInput(audioInput)
        
        self.captureSession.commitConfiguration()
    }
    
    // 사용 가능한 카메라 타입 획득
    func getVideoDevice() -> AVCaptureDevice {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        
        switch self.currentPosition {
            case .unspecified, .front:
            guard let device = discoverySession.devices.first(where: { $0.position == .back }) else {
                fatalError("Can't use rear camera")
            }
            self.currentPosition = .back
            return device
            
            case .back:
            guard let device = discoverySession.devices.first(where: { $0.position == .front }) else {
                fatalError("Can't use front camera")
            }
            self.currentPosition = .front
            return device
            
            @unknown default:
                fatalError("Unknown capture position.")
        }
    }
    
    // MARK: - 버튼 탭 핸들러
    @objc func didTapButtonHandler(_ sender: UIButton) {
        switch sender {
        case closeButton:
            self.dismiss(animated: true) {
                self.captureSession.stopRunning()
            }
        case thumbnailButton:
            return
        case recordButton:
            if self.isRecording {
                stopRecording()
            } else {
                startRecording()
            }
        case switchButton:
            switchVideoDevice()
        default:
            return
        }
    }
    
    func startRecording() {
        guard captureSession.isRunning else { return }
        
        let fileName = Date().dateToFileString + ".mp4"
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let fileURL = paths.first?.appendingPathComponent(fileName) else { return }
    
        print(fileURL)
        self.videoOutput?.startRecording(to: fileURL, recordingDelegate: self)
    
        self.switchButton.isEnabled = false
        self.recordButton.setImage(UIImage(systemName: "stop.circle"), for: .normal)
        self.recordButton.tintColor = .white
        self.isRecording = true
    }
    
    func stopRecording() {
        guard captureSession.isRunning else { return }
        self.videoOutput?.stopRecording()
        
        self.switchButton.isEnabled = true
        self.recordButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
        self.recordButton.tintColor = .systemRed
        self.isRecording = false
    }
    
    func switchVideoDevice() {
        
        let videoDevice = getVideoDevice()
        
        self.captureSession.beginConfiguration()

        guard let oldVideoInput = self.captureSession.inputs.first else { return }
        self.captureSession.removeInput(oldVideoInput)
        
        guard let newVideoInput = try? AVCaptureDeviceInput(device: videoDevice),
              self.captureSession.canAddInput(newVideoInput) else {
            self.captureSession.addInput(oldVideoInput)
            return
        }
        self.captureSession.addInput(newVideoInput)
        
        self.captureSession.commitConfiguration()
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
        var elapsedTime: Int = .zero
        self.timer = Timer(timeInterval: 1, repeats: true) { _ in
            elapsedTime += 1
            let minutes = String(format: "%02d", elapsedTime / 60)
            let seconds = String(format: "%02d", elapsedTime % 60)
            self.setTimerLabel(minutes: minutes, seconds: seconds)
        }
        
        
        if let timer = self.timer {
            RunLoop.current.add(timer, forMode: .default)
        }
        
    }
    
    // 포토 앨범에 비디오 추가
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard error == nil else {
            print("Error capturing video: \(String(describing: error))")
            return
        }
        
        self.timer?.invalidate()
        self.setTimerLabel()
        
        UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
    }
}
