//
//  WatchVideoViewController.swift
//  VideoRecorder
//
//  Created by Hyejeong Jeong on 2023/06/11.
//

import AVFoundation
import UIKit

final class WatchVideoViewController: UIViewController {
    var player = AVPlayer()
    lazy var playerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer(player: player)
        layer.frame = videoView.bounds
        layer.videoGravity = .resizeAspectFill
        return layer
    }()

    private var videoInfo: VideoInfo?
    
    private lazy var videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIOption()
        configureLayout()
        playVideo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoView.bounds
    }
    
    init(videoInfo: VideoInfo?) {
        self.videoInfo = videoInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUIOption() {
        view.backgroundColor = .white
        navigationItem.title = videoInfo?.fileName ?? "Untitle"
        
        let rightBarButtonIcon = UIImage(systemName: SystemImageName.information)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.systemGray2)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarButtonIcon,
                                                            style: .plain,
                                                            target: self,
                                                            action: nil)
    }
    
    private func playVideo() {
        guard let videoURL = videoInfo?.videoURL else { return }
        
        let url = URL(fileURLWithPath: videoURL.path)
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        videoView.layer.addSublayer(playerLayer)
        
        player.play()
    }
    
    private func configureLayout() {
        view.addSubview(videoView)
        videoView.layer.addSublayer(playerLayer)
        
        NSLayoutConstraint.activate([
            videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            videoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
