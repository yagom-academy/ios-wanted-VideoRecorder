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
    //playView
    @IBOutlet private weak var videoSlider: UISlider!
    @IBOutlet private weak var nowTimeLabel: UILabel!
    @IBOutlet private weak var totalTimeLabel: UILabel!
    @IBOutlet private weak var playButton: UIButton!
    
    private var player = AVPlayer()
    private var playerLayer: AVPlayerLayer?
    private let url: String = "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8"
    
    override func layoutSubviews() {
      super.layoutSubviews()
      self.playerLayer?.frame = self.backgroundView.bounds
    }
    
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
    
    func setVideoView() {
        guard let url = URL(string: self.url) else { return }
        let item = AVPlayerItem(url: url)
        self.player.replaceCurrentItem(with: item)
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame = self.backgroundView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.playerLayer = playerLayer
        self.backgroundView.layer.addSublayer(playerLayer)
        self.player.play()
       
        if self.player.status == .readyToPlay {
            self.videoSlider.minimumValue = 0
            self.videoSlider.maximumValue = Float(CMTimeGetSeconds(item.duration))
        }
 
        
        let interval = CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC))
        self.player.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] elapsedSeconds in
            let elapsedTimeSecondsFloat = CMTimeGetSeconds(elapsedSeconds)
            let totalTimeSecondsFloat = CMTimeGetSeconds(self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
            self?.nowTimeLabel.text = String(elapsedTimeSecondsFloat)
            self?.totalTimeLabel.text = String(totalTimeSecondsFloat)
            
            print(elapsedTimeSecondsFloat, totalTimeSecondsFloat)
        })
    }
    
}
