//
//  VideoListViewModel.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/06.
//

import Combine

final class VideoListViewModel {
    private let videoManager = VideoManager.shared
    
    func videoPublisher() -> AnyPublisher<[Video], Never> {
        return videoManager.$videoList
            .eraseToAnyPublisher()
    }
}
