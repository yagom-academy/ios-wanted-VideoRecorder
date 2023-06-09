//
//  RecordManager.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/08.
//

import AVFoundation
import Combine

final class RecordManager {
    enum RecordingError: LocalizedError {
        case noneCamera
        case noneAudioDevice
        case noneCameraInput
        case noneAudioInput
        case noneVideoOutput
        
        var errorDescription: String? {
            switch self {
            case .noneCamera: return "카메라 접근불가"
            case .noneAudioDevice: return "오디오 접근불가"
            case .noneCameraInput: return "카메라 입력접근불가"
            case .noneAudioInput: return "오디오 입력접근불가"
            case .noneVideoOutput: return "카메라 출력접근불가"
            }
        }
    }
    
    let captureSession = AVCaptureSession()
    var videoOutput: AVCaptureMovieFileOutput?
    var outputURL: URL?
    
    func setupCamera() throws {
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else {
            throw RecordingError.noneCamera
        }
        
        guard let backInput = try? AVCaptureDeviceInput(device: backCamera),
              captureSession.canAddInput(backInput) else {
            throw RecordingError.noneCameraInput
        }
        
        videoOutput = AVCaptureMovieFileOutput()
        guard let videoOutput else {
            throw RecordingError.noneVideoOutput
        }
        
        captureSession.addInput(backInput)
        captureSession.addOutput(videoOutput)
    }
    
    func setupAudio(with permission: Bool) throws {
        guard let audio = AVCaptureDevice.default(for: .audio) else {
            throw RecordingError.noneAudioDevice
        }
        
        guard let audioInput = try? AVCaptureDeviceInput(device: audio),
              captureSession.canAddInput(audioInput) else {
            throw RecordingError.noneAudioInput
        }
        
        captureSession.addInput(audioInput)
    }
    
    func makePreview(size: CGSize) -> AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.bounds = CGRect(origin: .zero, size: size)
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        return previewLayer
    }
    
    func startCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func processRecording(delegate: AVCaptureFileOutputRecordingDelegate) {
        guard let videoOutput else { return }
        
        if !videoOutput.isRecording {
            let connection = videoOutput.connection(with: AVMediaType.video)
            connection?.videoOrientation = .portrait
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let uniqueFileName = UUID().uuidString + ".mp4"
            let outputFileURL = documentsDirectory?.appendingPathComponent(uniqueFileName)
            
            guard let outputFileURL else { return }
            
            videoOutput.startRecording(to: outputFileURL, recordingDelegate: delegate)
        } else {
            stopRecording()
        }
    }
    
    func switchCamera() {
        guard videoOutput?.isRecording == false else { return }
        
        captureSession.beginConfiguration()
        let currentVideoInput = captureSession.inputs.first(where: { input in
            guard let input = input as? AVCaptureDeviceInput else {
                return false
            }
            
            return input.device.hasMediaType(.video)
        }) as? AVCaptureDeviceInput
        
        guard let currentVideoInput else { return }
        
        captureSession.removeInput(currentVideoInput)
        
        guard let newCameraDevice = currentVideoInput.device.position == .back ? camera(with: .front) : camera(with: .back) else {
            return
        }
        guard let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice) else {
            return
        }
        
        captureSession.addInput(newVideoInput)
        captureSession.commitConfiguration()
    }
    
    func generateThumbnail(videoURL: URL, completion: @escaping (CGImage?) -> Void) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: videoURL)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(image)
                } else {
                    completion(nil)
                }
            })
        }
    }
    
    private func camera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera, .builtInTrueDepthCamera],
            mediaType: .video,
            position: .unspecified
        )
        let devices = discoverySession.devices
        
        return devices.first(where: { device in device.position == position })
    }
    
    private func stopRecording() {
        videoOutput?.stopRecording()
    }
}
