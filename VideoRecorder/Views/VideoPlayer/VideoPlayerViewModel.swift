//
//  VideoPlayerViewModel.swift
//  VideoRecorder
//
//  Created by CodeCamper on 2022/10/12.
//

import Foundation
import UIKit
import Combine
import AVKit

class VideoPlayerViewModel {
    // MARK: Input
    enum Action {
        case toggleIsPlaying
        case setIsPlaying(Bool)
        case seekToCurrentTime
        
        case updateCurrentTimeWithProgress(Double)
        case rewind
        
        case setIsEditingCurrentTime(Bool)
    }
    
    // MARK: Output
    @Published var player: AVPlayer = AVPlayer()
    @Published var metaData: VideoMetaData
    @Published var currentTime: Double = 0
    @Published var isEditingCurrentTime: Bool = false
    
    // MARK: Properties
    var action = PassthroughSubject<Action, Never>()
    var subscriptions = [AnyCancellable]()
    
    // MARK: Life Cycle
    init(metaData: VideoMetaData) {
        self.metaData = metaData
        action
            .sink(receiveValue: { [weak self] action in
                guard let self else { return }
                self.mutate(action: action)
            })
            .store(in: &subscriptions)
        bind()
    }
    
    // MARK: Mutate
    func mutate(action: Action) {
        switch action {
        case .rewind:
            player.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero)
        case .setIsPlaying(let shouldPlay):
            if shouldPlay {
                player.play()
            } else {
                player.pause()
            }
        case .setIsEditingCurrentTime(let isEditing):
            if isEditingCurrentTime != isEditing {
                isEditingCurrentTime = isEditing
            }
        case .seekToCurrentTime:
            self.player.seek(to: CMTime(seconds: currentTime, preferredTimescale: 600), toleranceBefore: .zero, toleranceAfter: .zero)
            
        case .toggleIsPlaying:
            if player.timeControlStatus == .paused {
                player.play()
            } else {
                player.pause()
            }
        case .updateCurrentTimeWithProgress(let progress):
            let currentTime = progress * metaData.videoLength
            if self.currentTime != currentTime {
                self.currentTime = currentTime
            }
        }
    }
    
    // MARK: Bind
    func bind() {
        $metaData
            .compactMap { $0.videoPath }
            .flatMap { VideoManager.shared.getVideoIfNeeded($0) }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] url in
                guard let self else { return }
                let item = AVPlayerItem(url: url)
                self.player.replaceCurrentItem(with: item)
                self.player.play()
            }).store(in: &subscriptions)
        
        $isEditingCurrentTime
            .removeDuplicates()
            .filter { $0 == false }
            .dropFirst()
            .map { _ in Action.seekToCurrentTime }
            .subscribe(action)
            .store(in: &subscriptions)
        
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
            .map { _ in Action.setIsPlaying(false) }
            .subscribe(action)
            .store(in: &subscriptions)
        
        Timer.publish(every: 1 / 600, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] timer in
                guard
                    let self,
                    !self.isEditingCurrentTime,
                    self.player.currentItem != nil
                else { return }
                self.currentTime = self.player.currentTime().seconds
            }.store(in: &subscriptions)
    }
}
