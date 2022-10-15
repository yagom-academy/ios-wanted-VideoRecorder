//
//  CoreDataManager.swift
//  VideoRecorder
//
//  Created by CodeCamper on 2022/10/11.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    var persistentContainer: NSPersistentContainer { get }
    var context: NSManagedObjectContext { get }
    
    /// CoreData에 영상들의 MetaData 목록을 요청합니다.
    /// - Parameter start: MetaData 목록의 시작 Index입니다.
    /// - Returns: 시작 Index로부터 최대 6개의 VideoMetaData 목록을 반환합니다.
    func fetchVideoMetaData(start: Int) throws -> [VideoMetaData]
    
    /// CoreData와 상호작용할 수 있는 VideoMetaData 객체를 요청합니다.
    /// 함수의 호출에 사용되는 Parameter들은 생성되는 VideoMetaData의 초기값으로 설정됩니다.
    /// - Returns: 새롭게 생성된 VideoMetaData 객체를 반환합니다.
    func createNewVideoMetaData(name: String, createdAt: Date, videoPath: URL, thumbnail: Data, videoLength: Double) throws -> VideoMetaData
    
    /// CoreData에 새 레코드 생성을 요청합니다.
    /// - Parameter data: 레코드에 삽입될 VideoMetaData 객체입니다.
    func insertVideoMetaData(_ data: VideoMetaData) throws
    
    /// CoreData에서 특정 레코드의 삭제를 요청합니다.
    /// - Parameter data: 삭제할 VideoMetaData 객체입니다.
    func deleteVideoMetaData(_ data: VideoMetaData) throws
}


class CoreDataManager: CoreDataManagerProtocol {
    // MARK: Singleton
    static let shared = CoreDataManager()
    
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func fetchVideoMetaData(start: Int) throws -> [VideoMetaData] {
        let request = VideoMetaData.fetchRequest()
        request.fetchLimit = 6
        request.fetchOffset = start
        let result = try self.context.fetch(request)
        return result
    }
    
    func createNewVideoMetaData(name: String, createdAt: Date, videoPath: URL, thumbnail: Data, videoLength: Double) throws -> VideoMetaData {
        guard let entity = NSEntityDescription.entity(forEntityName: VideoMetaData.className, in: self.context) else { throw CoreDataManagerError.entityError }
        let metaData = VideoMetaData(entity: entity, insertInto: self.context)
        metaData.name = name
        metaData.createdAt = createdAt
        metaData.videoPath = videoPath
        metaData.thumbnail = thumbnail
        metaData.videoLength = videoLength
        return metaData
    }
    
    func insertVideoMetaData(_ data: VideoMetaData) throws {
        try self.context.save()
    }
    
    func deleteVideoMetaData(_ data: VideoMetaData) throws {
        self.context.delete(data)
        try self.context.save()
    }
}
