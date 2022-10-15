//
//  RecordingViewController.swift
//  VideoRecorder
//
//  Created by KangMingyo on 2022/10/11.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    var videoDevice: AVCaptureDevice!
    var audioDevice: AVCaptureDevice!
    var videoOutput: AVCaptureMovieFileOutput!
    var outputURL: URL?

    var recodeBool = Bool()
    var timer = Timer()
    var time = 0

    let recordingView: RecordingView = {
       let view = RecordingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingCamera()

        addSubView()
        configure()
        
        recodeBool = true
        recordingView.cencelButton.addTarget(self, action: #selector(cencelButtonPressed), for: .touchUpInside)
        recordingView.rotateButton.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)
        recordingView.recordingButton.addTarget(self, action: #selector(recordingVideo), for: .touchUpInside)
    }
    
    func settingCamera() {
        
        captureSession.sessionPreset = .high
        captureSession.beginConfiguration()
        
        videoDevice = bestDevice(in: .back)
        guard let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoInput) else { return }
        captureSession.addInput(videoInput)
        
        self.videoOutput = AVCaptureMovieFileOutput()
        guard let videoOutput = self.videoOutput else { return }
        guard self.captureSession.canAddOutput(videoOutput) else { return }
        self.captureSession.addOutput(videoOutput)
        
        captureSession.commitConfiguration()

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = self.view.frame
        self.view.layer.addSublayer(previewLayer)

        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    private func bestDevice(in position: AVCaptureDevice.Position) -> AVCaptureDevice {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera],
            mediaType: .video,
            position: .unspecified
        )
        
        let devices = discoverySession.devices
        guard !devices.isEmpty else { fatalError("Missing capture devices.")}
        
        return devices.first(where: { device in device.position == position })!
    }
    
    @objc func cencelButtonPressed() {
        self.dismiss(animated: true)
    }
    
    @objc func recordingVideo() {
        if recodeBool == true {
            recordingStart()
            videoTimerStart()
            recordingView.rotateButton.isEnabled = false
            recordingView.cencelButton.isEnabled = false
        } else {
            recordingStop()
            videoTimerStop()
            recordingView.rotateButton.isEnabled = true
            recordingView.cencelButton.isEnabled = true
        }
        recodeBool = !recodeBool
    }
    
    // Recording Start
    func recordingStart() {
        outputURL = VideoManager.shared.getVideoURL()

        videoOutput.startRecording(to: outputURL!, recordingDelegate: self)
    }
    
    func recordingStop() {
        if videoOutput.isRecording {
            videoOutput.stopRecording()
        }
    }
    
    // Timer Start
    func videoTimerStart() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
            self.time += 1
            recordingView.timeLabel.text = timeString(from: TimeInterval(time))
        }
    }
    
    func videoTimerStop() {
        timer.invalidate()
        time = 0
        recordingView.timeLabel.text = "00:00"
    }
    
    func timeString(from timeInterval: TimeInterval) -> String {
        let seconds = Int(timeInterval.truncatingRemainder(dividingBy: 60))
        let minutes = Int(timeInterval.truncatingRemainder(dividingBy: 60 * 60) / 60)
        return String(format: "%.2d:%.2d", minutes, seconds)
    }
    
    //카메라 방향 전환
    @objc func switchCamera() {
        captureSession.beginConfiguration()
        let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput
        captureSession.removeInput(currentInput!)
        let newCameraDevice = currentInput?.device.position == .back ? getCamera(with: .front) : getCamera(with: .back)
        let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice!)
        captureSession.addInput(newVideoInput!)
        captureSession.commitConfiguration()
    }

    func getCamera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {

        guard let devices = AVCaptureDevice.devices(for: AVMediaType.video) as? [AVCaptureDevice] else {
            return nil
        }
        return devices.filter {
            $0.position == position
            }.first
    }

    func addSubView() {
        view.addSubview(recordingView)
    }
    
    func configure() {
        NSLayoutConstraint.activate([
            recordingView.topAnchor.constraint(equalTo: view.topAnchor),
            recordingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recordingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recordingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension RecordingViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if (error != nil) {
            debugPrint("Error recording movie: \(error!.localizedDescription)")
        } else {
            let videoURL = outputURL! as URL
            var resultMetaData: VideoMetaData?
            VideoManager.shared.saveVideo(name: "Test", path: videoURL) { result in
                switch result {
                case .success(let metaData):
                    resultMetaData = metaData
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
            //로컬에 저장
            UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path, nil, nil, nil)
        }
    }
}
