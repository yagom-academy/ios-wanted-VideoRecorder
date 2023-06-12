//
//  DBUseCase.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/09.
//

import Foundation
import RealmSwift

protocol DBUseCase {
    
    func create(_ object: Object)
    
    func read() -> [Object]?
    
    func update(_ object: Object)
    
    func delete(_ id: UUID)
}
