//
//  PlayVideoViewModel.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/09.
//

import AVFoundation
import Combine

final class PlayVideoViewModel {
    @Published var isTouchUpBackwardButton: Bool = false
    @Published var isPlaying: Bool = true
    @Published var isTouchUpShareButton: Bool = false
    
    @Published var currentTime: String = ""
    @Published var duration: String = ""
    
    func updateCurrentTime(currentTime: CMTime) {
        self.currentTime = currentTime.formattedTime
    }
    
    func updateDuration(duration: CMTime) {
        self.duration = duration.formattedTime
    }
}
