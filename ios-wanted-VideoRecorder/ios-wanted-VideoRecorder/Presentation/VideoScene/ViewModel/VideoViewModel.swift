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
    
    @Published var videoTimeRatio: Double = 0 {
        didSet {
            if -0.02 > (videoTimeRatio - oldValue) ||
                (videoTimeRatio - oldValue) > 0.02 {
            changedVideoTime(timeRatio: videoTimeRatio)
        }
    }
}
    @Published var currentTime: String = "00:00"
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
    }
    
    private func changedVideoTime(timeRatio: Double) {
        guard let duration = videoPlayer.currentItem?.duration,
              !(timeRatio.isNaN || timeRatio.isInfinite) else {
            return
        }
        
        let value = timeRatio * CMTimeGetSeconds(duration)
        let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        
        videoPlayer.seek(to: seekTime)
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
        let updatedInterval = CMTimeMake(value: 100, timescale: 600)
        
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
        
        let currentSecond = Int(currentTime)
        let minute = currentSecond / 60
        let second = currentSecond % 60
        
        self.currentTime = String(format: "%02d:%02d", minute, second)
    }
    
    private func playVideo() {
        videoPlayer.play()
    }
    
    private func pauseVideo() {
        videoPlayer.pause()
    }
}
