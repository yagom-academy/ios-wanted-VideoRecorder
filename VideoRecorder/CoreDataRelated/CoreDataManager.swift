//
//  CoreDataManager.swift
//  VideoRecorder
//
//  Created by pablo.jee on 2022/10/13.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func fetchData() -> [VideoModel] {
        let request = VideoEntity.fetchRequest()
        
        let result = (try? self.context.fetch(request)) ?? []
        let model = result.map { VideoModel(videoEntity: $0) }
        return model
    }
    
    func saveData(_ model: VideoModel) {
        guard let entity = NSEntityDescription.entity(forEntityName: "VideoEntity", in: self.context) else { return }
        let video = VideoEntity(entity: entity, insertInto: self.context)
        video.imageURL = model.imageURL
        video.id = model.id
        video.videoFileURL = model.videoFileURL
        video.date = model.date
        video.duration = model.duration
        video.name = model.name
        // TODO: error handling
        try? self.context.save()
    }
    
    // TODO: error handling
    func removeData(_ model: VideoModel) {
        let request = VideoEntity.fetchRequest()
        
        let result = (try? self.context.fetch(request)) ?? []
        guard let video = result.first(where: { $0.id == model.id }) else {
            return
        }
        self.context.delete(video)
        try? self.context.save()
    }
}
