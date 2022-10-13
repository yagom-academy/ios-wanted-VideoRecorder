//
//  CoreDataManager.swift
//  VideoRecorder
//
//  Created by Subin Kim on 2022/10/13.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    var context: NSManagedObjectContext { return self.persistentContainer.viewContext }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VideoModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func fetchData(_ offset: Int) -> [VideoData] {
        let request = VideoData.fetchRequest()
        request.fetchLimit = 6
        request.fetchOffset = offset

        do {
            let fetchedData = try context.fetch(request)
            return fetchedData
        } catch {
            print("Error fetching data from context")
            print(error)
            return []
        }
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func deleteData(_ target: VideoData) {
        context.delete(target)
        saveContext()
    }
}
