//
//  MediaViewController.swift
//  VideoRecorder
//
//  Created by 신병기 on 2022/10/14.
//

import UIKit
import AVFoundation
import AVKit

class MediaViewController: UIViewController {
    static var identifier: String { String(describing: self) }
    
    @IBOutlet weak var mediaView: MediaView!
    @IBOutlet weak var controlView: UIView!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var elapsedLengthLabel: UILabel!
    @IBOutlet weak var totalLengthLabel: UILabel!
    
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    private var isPlaying: Bool = false
    private var observer: Any?
    
    var videoModel: VideoModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupUI()
    }
    
    func setupData() {
        guard let videoModel = self.videoModel else { return }
        self.mediaView.player = AVPlayer(url: videoModel.fileURL)
        
        self.elapsedLengthLabel.text = "00:00"
        let time = CMTimeConvertScale(videoModel.time, timescale: 1000000000, method: .roundAwayFromZero)
        let minutes = String(format: "%02d", Int(time.seconds) / 60)
        let seconds = String(format: "%02d", Int(time.seconds) % 60)
        self.totalLengthLabel.text = "\(minutes):\(seconds)"
        self.slider.maximumValue = Float(time.value)
    }
    
    func setupUI() {
        self.controlView.layer.cornerRadius = 25
        
        mediaView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapViewHandler)))
        
        slider.addTarget(self, action: #selector(didChangeSliderHandler), for: .valueChanged)
        
        [backwardButton, playButton, shareButton].forEach {
            $0?.addTarget(self, action: #selector(didTapButtonHandler(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: - 뷰 탭 핸들러
    @objc func didTapViewHandler(_ sender: UIView) {
        controlView.isHidden = !controlView.isHidden
    }
    
    // MARK: - 슬라이더 핸들러
    @objc func didChangeSliderHandler(_ sender: UIView) {
        self.pauseVideo()
        let sliderTime = CMTime(value: CMTimeValue(self.slider.value), timescale: 1000000000, flags: CMTimeFlags(rawValue: 1), epoch: 0)
        self.mediaView.player?.currentItem?.seek(to: sliderTime) { _ in
            let minutes = String(format: "%02d", Int(sliderTime.seconds) / 60)
            let seconds = String(format: "%02d", Int(sliderTime.seconds) % 60)
            self.elapsedLengthLabel.text = "\(minutes):\(seconds)"
        }
    }
    
    // MARK: - 버튼 탭 핸들러
    @objc func didTapButtonHandler(_ sender: UIButton) {
        switch sender {
        case backwardButton:
            resetVideo()
        case playButton:
            if self.isPlaying {
                pauseVideo()
            } else {
                playVideo()
            }
        case shareButton:
            return
        default:
            return
        }
    }
    
    func resetVideo() {
        pauseVideo()
        self.slider.value = 0.0
        self.elapsedLengthLabel.text = "00:00"
        self.mediaView.player?.currentItem?.seek(to: CMTime(seconds: .zero, preferredTimescale: CMTimeScale(NSEC_PER_SEC))) { _ in
            
        }
    }
    
    func playVideo() {
        self.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        self.isPlaying = true
        self.mediaView.player?.play()
        
        self.observer = self.mediaView.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main, using: {
            [weak self] time in
            let eplasedTime = time.seconds
            let eplasedTimeInt = Int(eplasedTime)
            let minutes = String(format: "%02d", eplasedTimeInt / 60)
            let seconds = String(format: "%02d", eplasedTimeInt % 60)
            self?.elapsedLengthLabel.text = "\(minutes):\(seconds)"
            guard let currentTime = self?.mediaView.player?.currentTime().value else { return }
            self?.slider.value = Float(currentTime)
            
            if time.timescale == 600 {
                self?.resetVideo()
            }
        })
    }
    
    func pauseVideo() {
        self.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        self.isPlaying = false
        self.mediaView.player?.pause()
        
        if let observer = self.observer {
            self.mediaView.player?.removeTimeObserver(observer)
            self.observer = nil
        }
    }
}
