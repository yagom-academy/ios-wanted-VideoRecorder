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
    
    let currentPlayTimeSubject: PassthroughSubject<Float, Never> = .init()
    
    private var videoPlayer: AVPlayer = AVPlayer()
    private var isPlayingVideo: Bool = false
    private var videoItem: AVPlayerItem
    
    init(fileURL: URL) {
        let item = AVPlayerItem(url: fileURL)
        self.videoItem = item
        videoPlayer.replaceCurrentItem(with: item)
        addObserverToPlayer()
    }
    
    func itemStatusPublisher() -> AnyPublisher<Float, Never> {
        return videoItem.publisher(for: \.status)
            .compactMap { [weak self] status in
                if status == .readyToPlay {
                    return self?.videoPlayer.currentItem?.duration
                }
                
                return nil
            }
            .map { duration in
                return Float(CMTimeGetSeconds(duration))
            }
            .eraseToAnyPublisher()
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
    
    private func addObserverToPlayer() {
        let timeInterval = CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC))
        videoPlayer.addPeriodicTimeObserver(
            forInterval: timeInterval,
            queue: .main
        ) { [weak self] currentTime in
            let value = Float(CMTimeGetSeconds(currentTime))
            self?.currentPlayTimeSubject.send(value)
        }
    }
}
