//
//  CoreDataManager.swift
//  VideoRecorder
//
//  Created by Hyejeong Jeong on 2023/06/10.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() { }
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Video")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    private var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    func create(videoInfo: VideoInfo) {
        let storage = VideoEntity(context: context)
        
        storage.setValue(videoInfo.id, forKey: "id")
        storage.setValue(videoInfo.videoURL, forKey: "videoURL")
        storage.setValue(videoInfo.thumbnailImage, forKey: "thumbnailImage")
        storage.setValue(videoInfo.duration, forKey: "duration")
        storage.setValue(videoInfo.fileName, forKey: "fileName")
        storage.setValue(videoInfo.registrationDate, forKey: "registrationDate")
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
