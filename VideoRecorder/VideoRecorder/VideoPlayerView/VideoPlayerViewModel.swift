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
    
    let currentPlayTimeSubject: PassthroughSubject<(Float, String), Never> = .init()
    
    private var videoPlayer: AVPlayer = AVPlayer()
    private var isPlayingVideo: Bool = false
    private var videoItem: AVPlayerItem
    
    init(fileURL: URL) {
        let item = AVPlayerItem(url: fileURL)
        self.videoItem = item
        videoPlayer.replaceCurrentItem(with: item)
        addObserverToPlayer()
    }
    
    func itemStatusPublisher() -> AnyPublisher<(Float, String), Never> {
        return videoItem.publisher(for: \.status)
            .compactMap { [weak self] status in
                status == .readyToPlay ? self?.videoPlayer.currentItem?.duration : nil
            }
            .map { [weak self] duration in
                guard let self else { return (0, "") }
                
                let seconds = CMTimeGetSeconds(duration)
                let durationText = self.convertToTimeString(from: seconds)
                
                return (Float(seconds), durationText)
            }
            .eraseToAnyPublisher()
    }
    
    func timeControlStatusPublisher() -> AnyPublisher<AVPlayer.TimeControlStatus, Never> {
        return videoPlayer.publisher(for: \.timeControlStatus)
            .eraseToAnyPublisher()
    }
    
    struct Input {
        let playButtonTapped: AnyPublisher<Void, Never>
        let sliderValue: AnyPublisher<Double, Never>
    }
    struct Output {
        let isPlayingVideo: AnyPublisher<Void, Never>
        let timeSearched: AnyPublisher<Void, Never>
    }
    
    func transform(input: Input) -> Output {
        let isPlayingVideo = input.playButtonTapped
            .compactMap { [weak self] in
                self?.playOrPause()
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
    
    private func playOrPause() {
        if videoPlayer.timeControlStatus == .playing {
            videoPlayer.pause()
        } else {
            videoPlayer.play()
        }
    }
    
    private func addObserverToPlayer() {
        let timeInterval = CMTimeMakeWithSeconds(0.001, preferredTimescale: Int32(NSEC_PER_SEC))
        videoPlayer.addPeriodicTimeObserver(
            forInterval: timeInterval,
            queue: .main
        ) { [weak self] currentTime in
            guard let self else { return }
            
            let seconds = CMTimeGetSeconds(currentTime)
            let value = Float(seconds)
            let currentTimeText = self.convertToTimeString(from: seconds)
            self.currentPlayTimeSubject.send((value, currentTimeText))
        }
    }
    
    private func convertToTimeString(from second: Float64) -> String {
        let secondString = String(format: "%02d", Int(second.truncatingRemainder(dividingBy: 60)))
        let minuteString = String(format: "%02d", Int(second / 60))
        
        return "\(minuteString):\(secondString)"
    }
}
