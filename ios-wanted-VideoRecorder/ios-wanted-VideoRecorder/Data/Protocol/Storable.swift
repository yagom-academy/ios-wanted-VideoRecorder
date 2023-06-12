//
//  Storable.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/07.
//

import Foundation
import RealmSwift

protocol Storable {
    associatedtype T
    
    var id: UUID { get set }
    
    static func toRealmObject(_ object: T) -> Object
    static func toObject(_ object: Object) -> T?
}
