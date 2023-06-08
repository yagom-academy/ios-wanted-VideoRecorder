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
    @Published var isPlaying: Bool = false
    let video: Video
    
    init(video: Video) {
        self.video = video
    }
    
    func makePlayer() -> AVPlayer? {
        guard let url = video.videoURL else { return nil }
        
        return AVPlayer(url: url)
    }
}
