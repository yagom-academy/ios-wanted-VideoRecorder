//
//  CoreDataVideoPersistenceServiceProtocol.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/10.
//

import Combine

protocol CoreDataVideoPersistenceServiceProtocol {
    func fetchVideoEntities() -> AnyPublisher<[VideoEntity], Error>
    func createVideoEntity(_ videoEntity: VideoEntity) -> AnyPublisher<VideoEntity, Error>
}
