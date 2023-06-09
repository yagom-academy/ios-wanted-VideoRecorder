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
    @NSManaged public var thumbnail: Data?
    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var videoURL: URL?
    @NSManaged public var duration: String?
    @NSManaged public var id: UUID?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataVideoEntity> {
        return NSFetchRequest<CoreDataVideoEntity>(entityName: "Video")
    }
    
    func update(_ videoEntity: VideoEntity) {
        self.name = videoEntity.name
        
    }
}

extension CoreDataVideoEntity : Identifiable {
    
}
