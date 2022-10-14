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
    @IBOutlet private weak var playView: UIView!
    @IBOutlet private weak var videoSlider: UISlider!
    @IBOutlet private weak var nowTimeLabel: UILabel!
    @IBOutlet private weak var totalTimeLabel: UILabel!
    @IBOutlet private weak var playButton: UIButton!
    
    private var player = AVPlayer()
    private var playerLayer: AVPlayerLayer?
    private var playItem: AVPlayerItem?
    private let url: String = "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8"
    private var videoIsPlay: Bool = false
    private var playerItemContext = 0
    private let requiredAssetKeys = [
        "playable",
        "hasProtectedContent"
    ]
    
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
    
    @IBAction func tappedPlayButton(_ sender: UIButton) {
        self.videoIsPlay.toggle()
        if videoIsPlay == true {
            self.player.play()
            self.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            self.player.pause()
            self.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }

    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {

        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }

        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            guard let item = playItem else {
                print("no playItem!!!")
                return
            }
            // Switch over status value
            switch status {
            case .readyToPlay:
                print("ready!!!")
                self.playView.isHidden = false
                self.videoSlider.minimumValue = 0
                self.videoSlider.maximumValue = Float(CMTimeGetSeconds(item.duration))
            case .failed:
                debugPrint("Player item failed. See error.")
            default:
                debugPrint("Player item is not yet ready.")
            }
        }
    }
    
    private func setVideoView() {
        guard let url = URL(string: self.url) else { return }
        let asset = AVAsset(url: url)
        playItem = AVPlayerItem(asset: asset,
                                automaticallyLoadedAssetKeys: requiredAssetKeys)
        playItem?.addObserver(self,
                                   forKeyPath: #keyPath(AVPlayerItem.status),
                                   options: [.old, .new],
                                   context: &playerItemContext)
        self.player.replaceCurrentItem(with: playItem)
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame = self.backgroundView.bounds
        playerLayer.videoGravity = .resize
        self.playerLayer = playerLayer
        self.backgroundView.layer.addSublayer(playerLayer)
        self.settingIntevalPlayTime()
        self.videoSlider.addTarget(self, action: #selector(didChangedSliderValue), for: .valueChanged)
    }

    private func settingIntevalPlayTime() {
        let interval = CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC))
        self.player.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] elapsedSeconds in
            let elapsedTimeSecondsFloat = CMTimeGetSeconds(elapsedSeconds)
            let totalTimeSecondsFloat = CMTimeGetSeconds(self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
            if !elapsedTimeSecondsFloat.isNaN && !totalTimeSecondsFloat.isNaN {
                self?.nowTimeLabel.text = self?.changeFloatToTime(elapsedTimeSecondsFloat)
                self?.totalTimeLabel.text = self?.changeFloatToTime(totalTimeSecondsFloat)
            }
        })
    }
    
    private func changeFloatToTime(_ value: Float64) -> String {
        let minute = Int(value) / 60
        let second = Int(value) % 60
        return NSString(format: "%02d:%02d", minute, second) as String
    }
    
    @objc func didChangedSliderValue() {
        self.player.seek(to: CMTime(seconds: Double(self.videoSlider.value), preferredTimescale: Int32(NSEC_PER_SEC)), completionHandler: { _ in
          print("\(self.videoSlider.value)")
        })
    }
    
}
