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

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataVideoEntity> {
        return NSFetchRequest<CoreDataVideoEntity>(entityName: "Video")
    }

    @NSManaged public var name: String?
    @NSManaged public var fileExtension: String?
    @NSManaged public var date: Date?
    @NSManaged public var url: String?
    @NSManaged public var duration: String?
    @NSManaged public var id: UUID?

}

extension CoreDataVideoEntity : Identifiable {
    
}
