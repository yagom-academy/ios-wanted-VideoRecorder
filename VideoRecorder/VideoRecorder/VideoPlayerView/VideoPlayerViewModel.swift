//
//  VideoPlayerViewModel.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/09.
//

import AVFoundation

final class VideoPlayerViewModel {
    var playerLayer: AVPlayerLayer {
        return AVPlayerLayer(player: videoPlayer)
    }
    
    var videoDuration: Float {
        guard let duration = videoItem?.duration else { return .zero }
        
        return Float(CMTimeGetSeconds(duration))
    }
    
    private var videoPlayer: AVPlayer = AVPlayer()
    
    private var videoItem: AVPlayerItem?
    
    init(fileURLString: String) {
        let item = playerItem(fileURL: fileURLString)
        self.videoItem = item
        videoPlayer.replaceCurrentItem(with: item)
    }
    
    private func playerItem(fileURL: String) -> AVPlayerItem? {
        guard let url = URL(string: fileURL) else { return nil }
        let item = AVPlayerItem(url: url)
        
        return item
    }
}
