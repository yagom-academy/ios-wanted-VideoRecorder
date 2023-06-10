//
//  CoreDataPersistenceService.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/09.
//

import CoreData

final class CoreDataPersistenceService {
    private let coreDataModelName = "model"
    
    lazy var context: NSManagedObjectContext? = {
        guard self.isPersistentStoreLoaded else { return nil }
        let context = self.persistentContainer.viewContext
        return context
    }()
    
    private var isPersistentStoreLoaded = false
    private var persistentContainer: NSPersistentContainer
    
    init() {
        self.persistentContainer = NSPersistentContainer(name: self.coreDataModelName)
        self.persistentContainer.loadPersistentStores { [weak self] _, error in
            guard error == nil else { return }
            self?.isPersistentStoreLoaded = true
        }
    }
}
