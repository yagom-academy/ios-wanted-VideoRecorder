//
//  VideoUseCase.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/09.
//

import AVKit
import Foundation

struct VideoUseCase {
    let videoPlayer: AVPlayer
    
    init(videoPlayer: AVPlayer) {
        self.videoPlayer = videoPlayer
    }
    
    func playVideo() {
        videoPlayer.play()
    }
    
    func pauseVideo() {
        videoPlayer.pause()
    }
    
    func checkPlayingVideo() -> Bool {
        guard let durationTime = videoPlayer.currentItem?.duration else {
            return true
        }
        let nowTime = videoPlayer.currentTime()
        
        if durationTime == nowTime {
            return false
        }
        
        return true
    }
    
    func goBackVideo(by second: Int64) {
        guard let currentTime = videoPlayer.currentItem?.currentTime() else {
            return
        }
        let frame = CMTimeMake(value: second, timescale: 1)
        let subtractTime = CMTimeSubtract(currentTime, frame)
        
        videoPlayer.seek(to: subtractTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    func changedVideoTime(timeRatio: Double) {
        guard let duration = videoPlayer.currentItem?.duration,
              !(timeRatio.isNaN || timeRatio.isInfinite) else {
            return
        }
        
        let value = timeRatio * CMTimeGetSeconds(duration)
        let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        
        videoPlayer.seek(to: seekTime)
    }
}
