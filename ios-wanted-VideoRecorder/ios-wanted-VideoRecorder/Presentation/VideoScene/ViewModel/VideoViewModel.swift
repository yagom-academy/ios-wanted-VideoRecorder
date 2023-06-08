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
    let videoManager: VideoUseCase
    var videoPlayer: AVPlayer {
        return videoManager.videoPlayer
    }
    
    @Published var videoTimeRatio: Double = 0 {
        didSet {
            guard let duration = videoPlayer.currentItem?.duration else {
                return
            }
            
            let durationSeconds = CMTimeGetSeconds(duration)
            let diffSeconds = (videoTimeRatio - oldValue) * durationSeconds
            if -1 > diffSeconds ||
                    diffSeconds > 1 {
                videoManager.changedVideoTime(timeRatio: videoTimeRatio)
            }
        }
    }
    @Published var currentTime: String = "00:00"
    @Published var isPlaying: Bool = false {
        didSet {
            if isPlaying {
                videoManager.playVideo()
            } else {
                videoManager.pauseVideo()
            }
        }
    }
    
    init(video: Video) {
        self.video = video
        
        if let url = video.videoURL {
            let videoPlayer = AVPlayer(url: url)
            self.videoManager = VideoUseCase(videoPlayer: videoPlayer)
        } else {
            let videoPlayer = AVPlayer(playerItem: nil)
            self.videoManager = VideoUseCase(videoPlayer: videoPlayer)
        }
        
        configureVideo()
    }
    
    func goBackVideo() {
        videoManager.goBackVideo(by: 3)
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
        
        let isPlayingVideo = videoManager.checkPlayingVideo()
        
        if isPlayingVideo == false {
            self.isPlaying = false
        }
    }
}
