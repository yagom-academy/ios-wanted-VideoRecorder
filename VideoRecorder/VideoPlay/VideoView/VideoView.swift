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
    @IBOutlet weak var playView: UIView!
    @IBOutlet private weak var videoSlider: UISlider!
    @IBOutlet private weak var nowTimeLabel: UILabel!
    @IBOutlet private weak var totalTimeLabel: UILabel!
    @IBOutlet private weak var playButton: UIButton!
    
    private var player = AVPlayer()
    private var playerLayer: AVPlayerLayer?
    private var playItem: AVPlayerItem?
    var url: URL? {
            didSet {
                guard let url = url else { return }
                self.setUpVideoView(url)
            }
        }
    private var videoIsPlay: Bool = false
    private var playerItemContext = 0
    private let requiredAssetKeys = [
        "playable",
        "hasProtectedContent"
    ]
    private let tempCMTime = CMTimeMake(value: 1, timescale: 1)
    
    // MARK: - override
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        self.settingTarget()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
        self.settingTarget()
    }


    override func layoutSubviews() {
      super.layoutSubviews()
      self.playerLayer?.frame = self.backgroundView.bounds
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

            switch status {
            case .readyToPlay:
                print("ready!!!")
                print("전체 초🎃: \(Float(CMTimeGetSeconds(item.duration)))")
                self.playView.isHidden = false
                self.videoSlider.minimumValue = 0
                self.videoSlider.maximumValue = Float(CMTimeGetSeconds(item.duration))
                self.videoSlider.value = 0
                self.totalTimeLabel.text = changeFloatToTime(CMTimeGetSeconds(playItem?.duration ?? tempCMTime))
            case .failed:
                debugPrint("Player item failed. See error.")
            default:
                debugPrint("Player item is not yet ready.")
            }
        }
    }
    
    // MARK: - IBAction
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
    
    @IBAction func tappedBackwordButton(_ sender: UIButton) {
        let backword10Sec = CMTimeGetSeconds(playItem?.currentTime() ?? tempCMTime) - 10
        self.player.seek(to: CMTime(seconds: backword10Sec, preferredTimescale: Int32(NSEC_PER_SEC)))
    }
    
   // MARK: - private func
    private func settingTarget() {
        self.videoSlider.addTarget(self, action: #selector(didChangedSliderValue), for: .valueChanged)
    }
    
    private func setUpVideoView(_ url: URL) {
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
    }

    private func settingIntevalPlayTime() {
        let interval = CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC))
        self.player.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] elapsedSeconds in
            guard let self = self else { return }
            let elapsedTimeSecondsFloat = CMTimeGetSeconds(elapsedSeconds)
            if !elapsedTimeSecondsFloat.isNaN  {
                self.nowTimeLabel.text = self.changeFloatToTime(elapsedTimeSecondsFloat)
            }
        })
        
        let sliderInterval = CMTimeMakeWithSeconds(0.01, preferredTimescale: Int32(NSEC_PER_SEC))
        self.player.addPeriodicTimeObserver(forInterval: sliderInterval, queue: .main, using: { [weak self] elapsedSeconds in
            guard let self = self else { return }
            let elapsedTimeSecondsFloat = CMTimeGetSeconds(elapsedSeconds)
            if !elapsedTimeSecondsFloat.isNaN  {
                self.videoSlider.value = Float(elapsedTimeSecondsFloat)
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
