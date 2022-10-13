//
//  PlayVideoViewController.swift
//  VideoRecorder
//
//  Created by 권준상 on 2022/10/13.
//

import AVFoundation
import AVKit
import UIKit

class PlayVideoViewController: UIViewController {
    
    var player = AVPlayer()
    var playerViewController = AVPlayerViewController()
    
    lazy var navigationLeftBarButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        button.tintColor = Color.white
        button.titleLabel?.font = Font.title2
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setTitleColor(Color.white, for: .normal)
        button.marginImageWithText(margin: 20)
        button.addTarget(self, action: #selector(popButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
        configureNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
    }
    
    private func setLayouts() {
        view.backgroundColor = Color.black
    }
    
    private func configureNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationLeftBarButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: .none)
        navigationItem.rightBarButtonItem?.tintColor = Color.darkGray
    }
    
    private func playVideo() {
        let videoURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
        player = AVPlayer(url: videoURL!)
        playerViewController.player = player
        playerViewController.view.frame = self.view.bounds
        playerViewController.showsPlaybackControls = true
        self.view.addSubview(playerViewController.view)
        player.play()
        
//        guard let path = Bundle.main.path(forResource: "video", ofType:"m4v") else {
//            debugPrint("video.m4v not found")
//            return
//        }
//        let player = AVPlayer(url: URL(fileURLWithPath: path))
//        let playerController = AVPlayerViewController()
//        playerController.player = player
//        present(playerController, animated: true) {
//            player.play()
//        }
    }
    
    @objc func popButtonDidTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
