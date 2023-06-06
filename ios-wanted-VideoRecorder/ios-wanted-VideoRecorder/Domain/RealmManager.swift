//
//  RealmManager.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/06.
//

import RealmSwift

struct RealmManager<T: Object> {
    private var realm: Realm? {
        return try? Realm()
    }
    
    func create(_ object: T) {
        try? realm?.write {
            realm?.add(object)
        }
    }
    
    func read() -> [T]? {
        guard let objects = realm?.objects(T.self) else { return nil }
        
        return Array(objects)
    }
    
    func update() {
    }
    
    func delete(_ object: T) {
        try? realm?.write {
            realm?.delete(object)
        }
    }
}
