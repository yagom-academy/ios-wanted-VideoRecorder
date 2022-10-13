//
//  VideoData+CoreDataProperties.swift
//  VideoRecorder
//
//  Created by Subin Kim on 2022/10/13.
//
//

import Foundation
import CoreData


extension VideoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VideoData> {
        return NSFetchRequest<VideoData>(entityName: "VideoData")
    }

    @NSManaged public var name: String
    @NSManaged public var date: String
    @NSManaged public var playTime: String

}

extension VideoData : Identifiable {

}
