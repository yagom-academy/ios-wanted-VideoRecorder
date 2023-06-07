//
//  Video+CoreDataProperties.swift
//  ios-wanted-VideoRecorder
//
//  Created by 천승현 on 2023/06/07.
//
//

import Foundation
import CoreData


extension Video {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Video> {
        return NSFetchRequest<Video>(entityName: "Video")
    }

    @NSManaged public var name: String?
    @NSManaged public var fileExtension: String?
    @NSManaged public var date: Date?
    @NSManaged public var url: String?
    @NSManaged public var duration: String?

}

extension Video : Identifiable {

}
