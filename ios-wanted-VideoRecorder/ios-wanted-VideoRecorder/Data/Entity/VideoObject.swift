//
//  VideoObject.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/06.
//

import Foundation
import RealmSwift

final class VideoObject: Object {
    @objc dynamic var id = UUID()
    @objc dynamic var title: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var videoURLText: String? = nil
    @objc dynamic var videoLength: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
