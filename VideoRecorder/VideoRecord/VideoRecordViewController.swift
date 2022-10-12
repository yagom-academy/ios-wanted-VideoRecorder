        //
//  VideoRecodeViewController.swift
//  VideoRecorder
//
//  Created by 김지인 on 2022/10/11.
//

import UIKit
import AVFoundation

class VideoRecordViewController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var changeCameraButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    private enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }

    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private var isSessionRunning = false
    private var setupResult: SessionSetupResult = .notAuthorized
    private var videoDeviceInput: AVCaptureDeviceInput!
    private var movieFileOutput: AVCaptureMovieFileOutput?

    // MARK: - View-Related Notifications
    override func viewDidLoad() {
        super.viewDidLoad()
        // AVCaptureSession과 카메라 미리보기 Layer 연결
        previewView.session = session

        requestPermissions()

        sessionQueue.async {
            self.configureSession()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        sessionQueue.async {
            switch self.setupResult {
            case .success:
                self.session.startRunning()
                self.isSessionRunning = self.session.isRunning

            case .notAuthorized:
                DispatchQueue.main.async {
                    let changePrivacySetting = "접근 권한 설정을 변경해주세요."
                    let message = NSLocalizedString(changePrivacySetting, comment: "동영상 촬영을 위해 카메라 접근 권한이 필요합니다.")
                    let alertController = UIAlertController(title: "VideoRecorder", message: message, preferredStyle: .alert)

                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                            style: .cancel,
                                                            handler: nil))

                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "설정으로 이동"),
                                                            style: .`default`,
                                                            handler: { _ in
                                                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                                                                          options: [:],
                                                                                          completionHandler: nil)
                    }))

                    self.present(alertController, animated: true, completion: nil)
                }

            case .configurationFailed:
                DispatchQueue.main.async {
                    let alertMsg = "Alert message when something goes wrong during capture session configuration"
                    let message = NSLocalizedString("Unable to capture media", comment: alertMsg)
                    let alertController = UIAlertController(title: "VideoRecorder", message: message, preferredStyle: .alert)

                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                            style: .cancel,
                                                            handler: nil))

                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    // MARK: - Button Actions
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        navigationController?.isNavigationBarHidden = false
        self.dismiss(animated: true)
    }

    @IBAction func recordButtonPressed(_ sender: UIButton) {
        guard let movieFileOutput = self.movieFileOutput else {
            return
        }

        recordButton.isEnabled = false
        changeCameraButton.isEnabled = false
        closeButton.isEnabled = false

        sessionQueue.async {
            if !movieFileOutput.isRecording {
                let movieFileOutputConnection = movieFileOutput.connection(with: .video)
                movieFileOutputConnection?.videoOrientation = .portrait

                let availableVideoCodecTypes = movieFileOutput.availableVideoCodecTypes

                if availableVideoCodecTypes.contains(.hevc) {
                    movieFileOutput.setOutputSettings([AVVideoCodecKey: AVVideoCodecType.hevc], for: movieFileOutputConnection!)
                }

                // Start recording video to a temporary file.
                let outputFileName = NSUUID().uuidString
                let outputFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent((outputFileName as NSString).appendingPathExtension("mp4")!)
                movieFileOutput.startRecording(to: URL(fileURLWithPath: outputFilePath), recordingDelegate: self)
            } else {
                movieFileOutput.stopRecording()
            }
        }

    }

    @IBAction func changeButtonPressed(_ sender: UIButton) {
        recordButton.isEnabled = false
        changeCameraButton.isEnabled = false
        closeButton.isEnabled = false

        sessionQueue.async {
            let currentVideoDevice = self.videoDeviceInput.device
            let currentPosition = currentVideoDevice.position

            let backVideoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                                       mediaType: .video, position: .back)
            let frontVideoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                                    mediaType: .video, position: .front)
            var newVideoDevice: AVCaptureDevice? = nil

            switch currentPosition {
            case .unspecified, .front:
                newVideoDevice = backVideoDeviceDiscoverySession.devices.first

            case .back:
                newVideoDevice = frontVideoDeviceDiscoverySession.devices.first

            @unknown default:
                print("Unknown capture position. Defaulting to back, dual-camera.")
                newVideoDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
            }

            if let videoDevice = newVideoDevice {
                do {
                    let newVideoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)

                    self.session.beginConfiguration()
                    self.session.removeInput(self.videoDeviceInput)

                    if self.session.canAddInput(newVideoDeviceInput) {
                        self.session.addInput(newVideoDeviceInput)
                        self.videoDeviceInput = newVideoDeviceInput
                    } else {
                        self.session.addInput(self.videoDeviceInput)
                    }

                    if let connection = self.movieFileOutput?.connection(with: .video) {
                        self.session.sessionPreset = .high

                        if connection.isVideoStabilizationSupported {
                            connection.preferredVideoStabilizationMode = .auto
                        }
                    }

                    self.session.commitConfiguration()
                } catch {
                    print("Error occurred while creating video device input: \(error)")
                }
            }

            DispatchQueue.main.async {
                self.recordButton.isEnabled = self.movieFileOutput != nil
                self.changeCameraButton.isEnabled = true
                self.closeButton.isEnabled = true
            }
        }
    }
}

extension VideoRecordViewController {
    func requestPermissions() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { response in
            if response {
                print("카메라 권한 허용")
                self.setupResult = .success
            } else {
                print("카메라 권한 거부")
                self.setupResult = .notAuthorized
            }
        })

        AVAudioSession.sharedInstance().requestRecordPermission{ response in
            if response {
                print("마이크 권한 허용")
                self.setupResult = .success
            } else {
                print("마이크 권한 거부")
                self.setupResult = .notAuthorized
            }
        }

        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setupResult = .success
            break

        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { accepted in
                if !accepted {
                    self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            })

        default:
            setupResult = .notAuthorized
        }
    }

    func configureSession() {
        if setupResult != .success { return }

        session.beginConfiguration()
        session.sessionPreset = .high

        let defaultVideoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)

        // 비디오 입력 장치 연결
        do {
            guard let videoDevice = defaultVideoDevice else {
                print("Default video device is unavailable.")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }

            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)

            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput

                DispatchQueue.main.async {
                    self.previewView.videoPreviewLayer.connection?.videoOrientation = .portrait
                }
            } else {
                print("Couldn't add video device input to the session.")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }

        } catch {
            print("Couldn't create video device input: \(error)")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }

        // 오디오 입력 장치 연결
        do {
            let audioDevice = AVCaptureDevice.default(for: .audio)
            let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice!)

            if session.canAddInput(audioDeviceInput) {
                session.addInput(audioDeviceInput)
            } else {
                print("Could not add audio device input to the session")
            }
        } catch {
            print("Could not create audio device input: \(error)")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }

        // 비디오 파일 출력 연결
        let movieFileOutput = AVCaptureMovieFileOutput()

        if self.session.canAddOutput(movieFileOutput) {
            self.session.addOutput(movieFileOutput)
            self.session.sessionPreset = .high

            if let connection = movieFileOutput.connection(with: .video) {
                if connection.isVideoStabilizationSupported {
                    connection.preferredVideoStabilizationMode = .auto
                }
            }
            self.movieFileOutput = movieFileOutput
        }

        session.commitConfiguration()
    }
}

extension VideoRecordViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.recordButton.isEnabled = true
            self.recordButton.setImage(UIImage(named: "stop"), for: [])
        }
    }

    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {

        if error != nil {
            print("Record file finishing error: \(String(describing: error))")
        }

        // 사진 앨범에 저장하려면 여기에 코드 삽입

        DispatchQueue.main.async {
            self.recordButton.isEnabled = true
            self.changeCameraButton.isEnabled = true
            self.closeButton.isEnabled = true
            self.recordButton.setImage(UIImage(named: "record"), for: [])
        }
    }
}
