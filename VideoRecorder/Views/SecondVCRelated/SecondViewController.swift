//
//  SecondViewController.swift
//  VideoRecorder
//
//  Created by pablo.jee on 2022/10/13.
//

import UIKit
import AVFoundation
import AVKit
import Photos
import MobileCoreServices


enum VideoHelper {
    static func startMediaBrowser(
        delegate: UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate,
        sourceType: UIImagePickerController.SourceType
    ) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType)
        else { return }

        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = sourceType
        mediaUI.mediaTypes = [kUTTypeMovie as String]
        mediaUI.allowsEditing = true
        mediaUI.delegate = delegate
        delegate.present(mediaUI, animated: true, completion: nil)
    }
}


class SecondViewController: UIViewController, SecondViewControllerRoutable {
    
    var model: SecondModel
    var testButton = UIButton()
    var session: AVCaptureSession?
    var backInput : AVCaptureInput?
    var frontInput : AVCaptureInput?
    var videoOutput : AVCaptureVideoDataOutput?
    let output = AVCapturePhotoOutput()  //사진촬영
    let previewLayer = AVCaptureVideoPreviewLayer()
    var backCameraOn = true
    private(set) var isRecording: Bool = false
    let playerViewController = AVPlayerViewController()
    let player = AVPlayer()
  
    private let sesstion1 = AVCaptureSession()
    let videoDevice = AVCaptureDevice.default(.builtInDuoCamera, for: .video, position: .back)
    
    
    init(viewModel: SecondModel) {
        self.model = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.layer.cornerRadius = 100
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    private let keepButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    private let switchCameraButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        button.layer.cornerRadius = 60
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    //    override func loadView() {
    //        initViewHierarchy()
    //        configureView()
    //        bind()
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sesstion1.sessionPreset = .high
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        view.addSubview(keepButton)
        view.addSubview(switchCameraButton)
        checkCameraPermissions()
        previewLayer.frame = view.bounds
        
        shutterButton.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height - 200)
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        keepButton.center = CGPoint(x: view.frame.size.width/5, y: view.frame.size.height - 200)
        keepButton.addTarget(self, action: #selector(keepPhoto), for: .touchUpInside)
        switchCameraButton.center = CGPoint(x: view.frame.size.width/1.25, y: view.frame.size.height - 200)
        switchCameraButton.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)
        
//        let videoDevice = bestDevice(in: .back)
        
        // Do any additional setup after loading the view.
    }
    

    
    
//    func bestDevice(in position: AVCaptureDevice.Position) -> AVCaptureDevice {
//        var deviceTypes: [AVCaptureDevice.DeviceType]!
//
//        if #available(iOS 11.1, *) {
//            deviceTypes = [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera]
//        } else {
//            deviceTypes = [.builtInDualCamera, .builtInWideAngleCamera]
//        }
//
//        let discoverySession = AVCaptureDevice.DiscoverySession(
//            deviceTypes: deviceTypes,
//            mediaType: .video,
//            position: .unspecified
//        )
//
//        let devices = discoverySession.devices
//        guard !devices.isEmpty else { fatalError("Missing capture devices.")}
//
//        return devices.first(where: { device in device.position == position })!
//    }
    
    func getVideoDevice() -> AVCaptureDevice {
            if let device = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .back) {
                return device
            } else if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
                return device
            } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                return device
            } else {
                fatalError("Missing expected back camera device.")
            }
        }
    
    func setupCaptureSession() {
           self.sesstion1.sessionPreset = .high
           self.sesstion1.beginConfiguration()
           
           let videoDevice = getVideoDevice()
           guard let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
                 self.sesstion1.canAddInput(videoInput) else { return }
           self.sesstion1.addInput(videoInput)
           
           let videoOutput = AVCaptureMovieFileOutput()
           guard self.sesstion1.canAddOutput(videoOutput) else { return }
           self.sesstion1.addOutput(videoOutput)
           
           self.sesstion1.commitConfiguration()
       }
    
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    private func setUpCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
            }
            catch {
                print(error)
            }
        }
    }
    // 촬영
    @objc private func didTapTakePhoto() {
        //        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
        
    }
    // 사진첩
    @objc private func keepPhoto() {
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
    }
    
    

    // 전 후 방 전환
    @objc func switchCamera() {
        if let session = session {
            guard let currentCameraInput: AVCaptureInput = session.inputs.first else {
                return
            }
            session.beginConfiguration()
            session.removeInput(currentCameraInput)
            
            var newCamera: AVCaptureDevice! = nil
            if let input = currentCameraInput as? AVCaptureDeviceInput {
                if (input.device.position == .back) {
                    newCamera = cameraWithPosition(position: .front)
                } else {
                    newCamera = cameraWithPosition(position: .back)
                }
            }
            var err: NSError?
            var newVideoInput: AVCaptureDeviceInput!
            do {
                newVideoInput = try AVCaptureDeviceInput(device: newCamera)
            } catch let err1 as NSError {
                err = err1
                newVideoInput = nil
            }
            if newVideoInput == nil || err != nil {
                print("Error creating capture device input: \(String(describing: err?.localizedDescription))")
            } else {
                session.addInput(newVideoInput)
            }
            session.commitConfiguration()
        }
    }
    
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */



extension SecondViewController: Presentable {
    func initViewHierarchy() {
        self.view = UIView()
        self.view.backgroundColor = .white
        
        self.view.addSubview(testButton)
        
        testButton.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        constraint += [
            testButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            testButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ]
    }
    
    func configureView() {
        testButton.setTitle("테스트", for: .normal)
        testButton.setTitleColor(.blue, for: .normal)
    }
    
    func bind() {
        model.routeSubject = { [weak self] scene in
            guard let self = self else { return }
            self.route(to: scene)
        }
        
        testButton.addTarget(self, action: #selector(customAction), for: .touchUpInside)
    }
    
    @objc func customAction() {
        model.didReceiveDoneRecoding()
    }
  
}


extension SecondViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        let image = UIImage(data: data)
        
        session?.stopRunning()
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.addSubview(imageView)
    }
    
}

extension SecondViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //동영상 저장
        if let url = info[.mediaURL] as? URL, UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path) {
            UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(savedVideo), nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }
        @objc func savedVideo(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer?) {
                    if let error = error {
                        print(error)
                        return
                    }
                    print("success")
                }
    }
