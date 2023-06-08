//
//  VideoEntity+CoreDataClass.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/08.
//
//

import Foundation
import CoreData

@objc(VideoEntity)
public class VideoEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VideoEntity> {
        return NSFetchRequest<VideoEntity>(entityName: "VideoEntity")
    }
    
    @NSManaged public var identifier: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var image: Data?
}

extension VideoEntity: DataAccessObject {
    typealias DataTransferObject = Video
    
    func setValues(from model: DataTransferObject) {

    }
    
    func updateValues(from model: DataTransferObject) {

    }
}
