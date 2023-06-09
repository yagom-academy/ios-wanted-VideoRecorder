//
//  VideoEntity+CoreDataProperties.swift
//  VideoRecorder
//
//  Created by Hyejeong Jeong on 2023/06/10.
//
//

import CoreData

extension VideoEntity {
    @nonobjc class func fetchRequest() -> NSFetchRequest<VideoEntity> {
        return NSFetchRequest<VideoEntity>(entityName: String(describing: VideoEntity.self))
    }

    @NSManaged var id: UUID?
    @NSManaged var videoURL: String?
    @NSManaged var thumbnailImage: Data?
    @NSManaged var duration: Double
    @NSManaged var fileName: String?
    @NSManaged var registrationDate: Date?
}

extension VideoEntity : Identifiable { }
