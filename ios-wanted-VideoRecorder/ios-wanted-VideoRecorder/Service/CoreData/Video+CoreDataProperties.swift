//
//  Video+CoreDataProperties.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/07.
//
//

import Foundation
import CoreData


extension CoreDataVideoEntity {
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var duration: String?
    @NSManaged public var thumbnail: Data?
    @NSManaged public var videoURL: URL?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataVideoEntity> {
        return NSFetchRequest<CoreDataVideoEntity>(entityName: "Video")
    }
    
    func toVideoEntity() -> VideoEntity? {
        guard let id, let name, let date, let duration, let thumbnail, let videoURL else { return nil }
        
        return VideoEntity(
            id: id,
            name: name,
            date: date,
            duration: duration,
            thumbnail: thumbnail,
            videoURL: videoURL
        )
    }
    
    func update(_ videoEntity: VideoEntity) {
        self.id = videoEntity.id
        self.name = videoEntity.name
        self.date = videoEntity.date
        self.duration = videoEntity.duration
        self.thumbnail = videoEntity.thumbnail
        self.videoURL = videoEntity.videoURL
    }
}

extension CoreDataVideoEntity : Identifiable {
    
}
