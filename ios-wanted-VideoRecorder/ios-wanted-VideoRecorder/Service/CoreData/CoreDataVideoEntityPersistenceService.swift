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
    case failedToFetchVideo
    case failedToDeleteVideo
    
    var errorDescription: String? {
        switch self {
        case .failedToInitializeCoreDataContainer:
            return "CoreDataContainer 초기화에 실패했습니다."
        case .failedToCreateVideo:
            return "Video 엔티티 생성에 실패했습니다."
        case .failedToFetchVideo:
            return "Video를 불러오지 못했습니다."
        case .failedToDeleteVideo:
            return "Video를 삭제하지 못했습니다."
        }
    }
}

final class CoreDataVideoEntityPersistenceService: CoreDataVideoPersistenceServiceProtocol {
    private let coreDataPersistenceService: CoreDataPersistenceServiceProtocol
    
    init(coreDataPersistenceService: CoreDataPersistenceServiceProtocol) {
        self.coreDataPersistenceService = coreDataPersistenceService
    }
    
    func fetchVideoEntities() -> AnyPublisher<[VideoEntity], Error> {
        guard let context = coreDataPersistenceService.context else {
            return Fail(error: CoreDataVideoEntityPersistenceServiceError.failedToFetchVideo)
                .eraseToAnyPublisher()
        }
        
        return Future { promise in
            context.perform {
                let fetchRequest = CoreDataVideoEntity.fetchRequest()
                
                do {
                    let fetchResult = try context.fetch(fetchRequest)
                    promise(.success(fetchResult.compactMap { $0.toVideoEntity() }))
                } catch {
                    promise(.failure(CoreDataVideoEntityPersistenceServiceError.failedToFetchVideo))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func createVideoEntity(_ videoEntity: VideoEntity) -> AnyPublisher<VideoEntity, Error> {
        guard let context = coreDataPersistenceService.context else {
            return Fail(error: CoreDataVideoEntityPersistenceServiceError.failedToInitializeCoreDataContainer)
                .eraseToAnyPublisher()
        }
        
        return Future { promise in
            context.perform {
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
    
    func deleteVideoEntity(videoID id: UUID) -> AnyPublisher<VideoEntity?, Error> {
        guard let context = coreDataPersistenceService.context else {
            return Fail(error: CoreDataVideoEntityPersistenceServiceError.failedToInitializeCoreDataContainer)
                .eraseToAnyPublisher()
        }
        
        return Future { promise in
            do {
                let fetchRequest = CoreDataVideoEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
                let fetchResult = try context.fetch(fetchRequest)
                guard let target = fetchResult.first else { throw CoreDataVideoEntityPersistenceServiceError.failedToDeleteVideo }
                let deletedVideoEntity = target.toVideoEntity()
                context.delete(target)
                try context.save()
                return promise(.success(deletedVideoEntity))
            } catch {
                return promise(.failure(CoreDataVideoEntityPersistenceServiceError.failedToDeleteVideo))
            }
        }
        .eraseToAnyPublisher()
    }
}



