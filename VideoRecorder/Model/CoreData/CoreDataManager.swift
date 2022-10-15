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
    var totalCount = 0

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
        do {
            let count = try context.count(for: request)
            print(count)
            totalCount = count
        } catch {
            print("context count error")
        }

        if totalCount <= offset { return [] }

        // 최신순으로 fetch하기
        var limit = 6
        var contextOffset = totalCount - offset - limit

        if contextOffset < 0 {
            limit += contextOffset
            contextOffset = 0
        }

        request.fetchOffset = contextOffset
        request.fetchLimit = limit

        do {
            let fetchedData = try context.fetch(request)
            return fetchedData.reversed()
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
