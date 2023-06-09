//
//  CoreDataVideoEntityPersistenceService.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/09.
//

import Combine
import CoreData

fileprivate enum CoreDataVideoEntityPersistenceServiceError: LocalizedError {
    case failedToInitializeCoreDataContainer
    case failedToCreateVideo
    
    var errorDescription: String? {
        switch self {
        case .failedToInitializeCoreDataContainer:
            return "CoreDataContainer 초기화에 실패했습니다."
        case .failedToCreateVideo:
            return "Video 엔티티 생성에 실패했습니다."
        }
    }
}

final class CoreDataVideoEntityPersistenceService {
    private let coreDataPersistenceService: CoreDataPersistenceServiceProtocol
    
    init(coreDataPersistenceService: CoreDataPersistenceServiceProtocol) {
        self.coreDataPersistenceService = coreDataPersistenceService
    }
    
    func createVideoEntity(_ videoEntity: VideoEntity) -> AnyPublisher<VideoEntity, Error> {
        guard let context = coreDataPersistenceService.context else {
            return Fail(error: CoreDataVideoEntityPersistenceServiceError.failedToInitializeCoreDataContainer)
                .eraseToAnyPublisher()
        }
        
        return Future { promise in
            context.perform {
                let fetchRequest = CoreDataVideoEntity.fetchRequest()
                let video = CoreDataVideoEntity(context: context)
                video.update(videoEntity)
                do {
                    try context.save()
                    promise(.success(videoEntity))
                } catch {
                    promise(.failure(CoreDataVideoEntityPersistenceServiceError.failedToCreateVideo))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}



