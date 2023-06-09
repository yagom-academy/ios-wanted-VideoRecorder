//
//  VideoListViewModel.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/06.
//

import Foundation
import Combine

final class VideoListViewModel {
    private let videoRecorderService = VideoRecorderService.shared
    
    func videoPublisher() -> AnyPublisher<[Video], Never> {
        return videoRecorderService.videoPublisher()
    }
    
    func delete(by indexPath: IndexPath) {
        videoRecorderService.delete(by: indexPath)
    }
    
    func requestVideo(by indexPath: IndexPath) -> Video? {
        return videoRecorderService.requestVideo(by: indexPath)
    }
}
