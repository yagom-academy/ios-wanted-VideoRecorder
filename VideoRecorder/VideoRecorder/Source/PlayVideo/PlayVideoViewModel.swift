//
//  PlayVideoViewModel.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/09.
//

import Combine

final class PlayVideoViewModel {
    @Published var isTouchUpBackwardButton: Bool = false
    @Published var isPlaying: Bool = false
    @Published var isTouchUpShareButton: Bool = false
}
