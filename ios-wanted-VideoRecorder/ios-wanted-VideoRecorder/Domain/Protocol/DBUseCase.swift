//
//  DBUseCase.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/09.
//

import Foundation
import RealmSwift

protocol DBUseCase {
    
    associatedtype T: Object
    
    func create(_ object: T)
    
    func read() -> [T]?
    
    func update(_ object: T)
    
    func delete(_ id: UUID)
}
