//
//  VideoViewModel.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/07.
//

import AVKit
import SwiftUI
import Foundation

final class VideoViewModel: ObservableObject {
    let video: Video
    var videoPlayer: AVPlayer
    
    @Published var videoTimeRatio: Double = 0
    @Published var currentTime: Float = 0
    @Published var durationTime: Float = 0
    @Published var isPlaying: Bool = false {
        didSet {
            if isPlaying {
                playVideo()
            } else {
                pauseVideo()
            }
        }
    }
    
    init(video: Video) {
        self.video = video
        
        if let url = video.videoURL {
            videoPlayer = AVPlayer(url: url)
        } else {
            videoPlayer = AVPlayer(playerItem: nil)
        }
        
        configureVideo()
        isPlaying = true
    }
    
    func moveToBackThreeSecond() {
        guard let currentTime = videoPlayer.currentItem?.currentTime() else {
            return
        }
        let frame = CMTimeMake(value: 3, timescale: 1)
        let subtractTime = CMTimeSubtract(currentTime, frame)
        
        videoPlayer.seek(to: subtractTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    private func configureVideo() {
        let updatedInterval = CMTimeMake(value: 1, timescale: 1)
        
        videoPlayer.addPeriodicTimeObserver(forInterval: updatedInterval, queue: DispatchQueue.main, using: { time in
            self.updateVideoSlider(time: time)
        })
    }
    
    private func updateVideoSlider(time: CMTime) {
        guard let currentItem = videoPlayer.currentItem else {
            return
        }
        
        let duration = CMTimeGetSeconds(currentItem.duration)
        let currentTime = CMTimeGetSeconds(time)
        
        self.videoTimeRatio = currentTime / duration
        
        self.durationTime = Float(duration)
        self.currentTime = Float(currentTime)
    }
    
    private func playVideo() {
        videoPlayer.play()
    }
    
    private func pauseVideo() {
        videoPlayer.pause()
    }
}
