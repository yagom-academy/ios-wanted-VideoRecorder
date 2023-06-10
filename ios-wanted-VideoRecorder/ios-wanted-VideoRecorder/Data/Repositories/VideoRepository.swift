//
//  VideoRepository.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/10.
//

import Foundation
import Combine

final class VideoRepository {
    private let videoEntityPersistenceService: CoreDataVideoPersistenceServiceProtocol
    let createdVideo = PassthroughSubject<VideoEntity, Never>()

    init(videoEntityPersistenceService: CoreDataVideoPersistenceServiceProtocol) {
        self.videoEntityPersistenceService = videoEntityPersistenceService
    }
    
    func fetchVideo() -> AnyPublisher<[VideoEntity], Error> {
        return videoEntityPersistenceService.fetchVideoEntities()
    }
    
    func createVideo(_ videoEntity: VideoEntity) -> AnyPublisher<VideoEntity, Error> {
        return videoEntityPersistenceService.createVideoEntity(videoEntity)
            .flatMap { [weak self] videoEntity -> AnyPublisher<VideoEntity, Error> in
                self?.createdVideo.send(videoEntity)
                
                return Just(videoEntity)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
