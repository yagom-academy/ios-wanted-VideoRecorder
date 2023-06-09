//
//  VideoPlayerViewModel.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/09.
//

import AVFoundation
import Combine

final class VideoPlayerViewModel: EventHandleable {
    var playerLayer: AVPlayerLayer {
        return AVPlayerLayer(player: videoPlayer)
    }
    
    var videoDuration: Float {
        guard videoItem?.status == .readyToPlay,
              let duration = videoItem?.duration else { return .zero }
        
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
    
    struct Input {
        let sliderValue: AnyPublisher<Double, Never>
    }
    struct Output {
        let timeSearched: AnyPublisher<Void, Never>
    }
    
    func transform(input: Input) -> Output {
        let timeSearched = input.sliderValue
            .compactMap { [weak self] time in
                self?.videoPlayer.seek(to: CMTime(seconds: time, preferredTimescale: 1))
            }
            .eraseToAnyPublisher()
        
        return Output(timeSearched: timeSearched)
    }
}
