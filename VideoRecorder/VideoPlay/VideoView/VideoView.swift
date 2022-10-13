//
//  VideoView.swift
//  VideoRecorder
//
//  Created by 김지인 on 2022/10/13.
//

import UIKit
import AVKit
import AVFoundation

final class VideoView: UIView {
    
    @IBOutlet private weak var backgroundView: UIView!
    
    private let url: String = "https://firebasestorage.googleapis.com/v0/b/videorecorder-a1153.appspot.com/o/0B5DE138-091E-4BB8-8F6C-2F34396A66A5.MOV?alt=media&token=c6075fb2-7372-415b-b2ff-37a41d7bd001"
    
    private var player = AVPlayer()
    private var playerLayer: AVPlayerLayer?
    
    lazy var playView: PlayView = {
        let view = PlayView()
        view.cornerRadius = 10
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        setVideoView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
        setVideoView()
    }
    
    private func setVideoView() {
        guard let url = URL(string: self.url) else { return }
        let item = AVPlayerItem(url: url)
        self.player.replaceCurrentItem(with: item)
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame = self.layer.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.playerLayer = playerLayer
        playView.frame = CGRect(x: 50, y: backgroundView.bounds.height - 200, width: 300, height: 120)
        self.backgroundView.layer.addSublayer(playerLayer)
        self.backgroundView.addSubview(playView)
        self.player.play()
    }
    // TODO: 고정 frame 값을 Constraint로
    private func setConstraint() {
        playView.translatesAutoresizingMaskIntoConstraints = true
        NSLayoutConstraint.activate([
             self.playView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 30),
             self.playView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -30),
             self.playView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -50),
             self.playView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
 
}
