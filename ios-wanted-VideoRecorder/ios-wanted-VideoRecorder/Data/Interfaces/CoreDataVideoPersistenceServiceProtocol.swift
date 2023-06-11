//
//  CoreDataVideoPersistenceServiceProtocol.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/10.
//

import Combine
import Foundation

protocol CoreDataVideoPersistenceServiceProtocol {
    func fetchVideoEntities() -> AnyPublisher<[VideoEntity], Error>
    func createVideoEntity(_ videoEntity: VideoEntity) -> AnyPublisher<VideoEntity, Error>
    func deleteVideoEntity(videoID id: UUID) -> AnyPublisher<VideoEntity?, Error>
}
