//
//  VideoModel+CoreDataProperties.swift
//  VideoRecorder
//
//  Created by 권준상 on 2022/10/15.
//

import Foundation
import CoreData


extension VideoModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VideoModel> {
        return NSFetchRequest<VideoModel>(entityName: "VideoModel")
    }

    @NSManaged public var identifier: UUID
    @NSManaged public var date: String
    @NSManaged public var runningTime: String
    @NSManaged public var name: String
    @NSManaged public var videoPath: String

}

extension VideoModel : Identifiable {

}
