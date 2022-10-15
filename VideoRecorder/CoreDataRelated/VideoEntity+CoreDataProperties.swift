//
//  VideoEntity+CoreDataProperties.swift
//  VideoRecorder
//
//  Created by pablo.jee on 2022/10/13.
//
//

import Foundation
import CoreData


extension VideoEntity {
    
    @NSManaged public var id: UUID?
    @NSManaged public var imageURL: String?
    @NSManaged public var videoFileURL: String?
    @NSManaged public var name: String?
    @NSManaged public var date: String?
    @NSManaged public var duration: String?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VideoEntity> {
        return NSFetchRequest<VideoEntity>(entityName: "VideoEntity")
    }


}

extension VideoEntity : Identifiable {

}

struct VideoModel {
    let id: UUID
    let date: String
    let duration: String
    let imageURL: String
    let name: String
    let videoFileURL: String
}

extension VideoModel {
    init(videoEntity: VideoEntity) {
        self.id = videoEntity.id ?? UUID()
        self.date = videoEntity.date ?? ""
        self.duration = videoEntity.duration ?? ""
        self.imageURL = videoEntity.imageURL ?? ""
        self.name = videoEntity.name ?? ""
        self.videoFileURL = videoEntity.videoFileURL ?? ""
    }
}
