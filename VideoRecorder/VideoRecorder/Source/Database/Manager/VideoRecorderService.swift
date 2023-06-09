//
//  VideoRecorderService.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/09.
//

import Foundation
import Combine

final class VideoRecorderService {
    static let shared = VideoRecorderService()
    
    private let videoManager = VideoManager.shared
    
    private init() {
//        videoManager.read()
    }
    
    func videoPublisher() -> AnyPublisher<[Video], Never> {
        return videoManager.$videoList
            .eraseToAnyPublisher()
    }
    
    func create(video: Video) {
        videoManager.create(video: video)
    }
    
    func read() {
        videoManager.read()
    }
    
    func update(video: Video) {
        videoManager.update(video: video)
    }
    
    func delete(video: Video) {
        videoManager.delete(video: video)
    }
    
    func delete(by indexPath: IndexPath) {
        videoManager.delete(by: indexPath)
    }
    
    func requestVideo(by indexPath: IndexPath) -> Video? {
        return videoManager.requestVideo(by: indexPath)
    }
}
