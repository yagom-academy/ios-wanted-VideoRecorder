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
        
        guard let url = video.videoURL else {
            videoPlayer = AVPlayer(playerItem: nil)
            return
        }
        
        videoPlayer = AVPlayer(url: url)
    }
    
    private func playVideo() {
        videoPlayer.play()
    }
    
    private func pauseVideo() {
        videoPlayer.pause()
    }
}
