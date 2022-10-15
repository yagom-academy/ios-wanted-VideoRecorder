//
//  VideoPlayViewController.swift
//  VideoRecorder
//
//  Created by 1 on 2022/10/11.
//

import UIKit
import AVKit
import AVFoundation
import Photos


class VideoPlayViewController: UIViewController, AVPlayerViewControllerDelegate {
    
    var playerLayer = AVPlayerViewController()
    //    var allPhotos: PHFetchResult<PHAsset>?
    //        self.allPhotos = PHAsset.fetchAssets(with: nil)  viewdidload
    let fileManager = FileManager.default
    
    let videoButton = UIButton()
    lazy var rightNavButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "⌾", style: .plain, target: self, action: #selector(add))
        return button
    }()
    lazy var leftNavButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "〈", style: .plain, target: self, action: #selector(back))
        return button
    }()
    @objc func add(_ sender: Any) {
    }
    @objc func back(_ sender: Any) {
        //        let firstView = firstViewController() // 첫번째 화면 푸시
        //        self.navigationController?.pushViewController(firstView, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = self.rightNavButton
        self.navigationItem.leftBarButtonItem = self.leftNavButton
        title = "네비바 제목"
        configureButton()
        fileManager
//        fileVideo()
        
    }
    ///파일 영상
    func fileVideo() {
        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "Sim", ofType: "mp4")!))
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc, animated: true)
    }
    func filesManager() {
        let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentURL.appendingPathComponent("Video")
        let helloPath = directoryURL.appendingPathComponent("Sim.mp4")
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: false, attributes: nil)
        } catch let e {
            print(e.localizedDescription)
        }
        
        if let data: Data = "안녕하세요".data(using: String.Encoding.utf8) {
            do {
                try data.write(to: helloPath)
            } catch let e {
                print(e.localizedDescription)
            }
        }
        do {
            try fileManager.removeItem(at: helloPath)
        } catch let e {
            print(e.localizedDescription)
        }
        
        do {
            let dataFromPath: Data = try Data(contentsOf: helloPath)
            let text: String = String(data: dataFromPath, encoding: .utf8) ?? "문서없음"
            print(text)
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    func configureButton() {
        videoButton.setTitle("▶️", for: .normal)
        videoButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(videoButton)
        let safeArea = view.safeAreaLayoutGuide
        videoButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20).isActive = true
        videoButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -220).isActive = true
        videoButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20).isActive = true
        
        videoButton.addTarget(self, action: #selector(buttontest(_:)), for: .touchUpInside)
    }
    @objc func buttontest(_ sender: UIButton) {
        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "Sim", ofType: "mp4")!))
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc, animated: true, completion: nil)
        if let btn = sender as? UIButton {
            btn.setTitle("⏸", for: .normal)
        } else {
        }
    }
    ///URL 영상
        func playVideo() {
            guard let videoURl = URL(string:  "https://wolverine.raywenderlich.com/content/ios/tutorials/video_streaming/foxVillage.mp4") else { return }
            let player = AVPlayer(url: videoURl)
            playerLayer = AVPlayerViewController()
            playerLayer.player = player
            playerLayer.allowsPictureInPicturePlayback = true
            playerLayer.delegate = self
            playerLayer.player?.play()
    
            self.present(playerLayer, animated: true, completion: nil)
        }
}




