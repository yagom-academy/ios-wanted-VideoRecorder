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
    
    let currentPlayTimeSubject: PassthroughSubject<Float, Never> = .init()
    
    private var videoPlayer: AVPlayer = AVPlayer()
    private var isPlayingVideo: Bool = false
    private var videoItem: AVPlayerItem?
    
    init(fileURLString: String) {
        let item = playerItem(fileURL: fileURLString)
        self.videoItem = item
        videoPlayer.replaceCurrentItem(with: item)
        addObserverToPlayer()
    }
    
    private func playerItem(fileURL: String) -> AVPlayerItem? {
        guard let url = URL(string: fileURL) else { return nil }
        let item = AVPlayerItem(url: url)
        
        return item
    }
    
    private func addObserverToPlayer() {
        let timeInterval = CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC))
        videoPlayer.addPeriodicTimeObserver(
            forInterval: timeInterval,
            queue: .main
        ) { [weak self] currentTime in
            guard let item = self?.videoItem else { return }
            
            let value = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(item.duration))
            self?.currentPlayTimeSubject.send(value)
        }
    }
    
    struct Input {
        let playButtonTapped: AnyPublisher<Void, Never>
        let sliderValue: AnyPublisher<Double, Never>
    }
    struct Output {
        let isPlayingVideo: AnyPublisher<Bool, Never>
        let timeSearched: AnyPublisher<Void, Never>
    }
    
    func transform(input: Input) -> Output {
        let isPlayingVideo = input.playButtonTapped
            .map { [weak self] in
                guard let self else { return false }
                
                return self.playVideo()
            }
            .eraseToAnyPublisher()
        
        let timeSearched = input.sliderValue
            .compactMap { [weak self] time in
                self?.videoPlayer.seek(
                    to: CMTime(seconds: time, preferredTimescale: Int32(NSEC_PER_SEC))
                )
            }
            .eraseToAnyPublisher()
        
        return Output(isPlayingVideo: isPlayingVideo,
                      timeSearched: timeSearched)
    }
    
    private func playVideo() -> Bool {
        if isPlayingVideo {
            videoPlayer.pause()
            isPlayingVideo.toggle()
            return false
        } else {
            videoPlayer.play()
            isPlayingVideo.toggle()
            return true
        }
    }
}
