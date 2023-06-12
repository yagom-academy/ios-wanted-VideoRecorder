//
//  CoreDataManager.swift
//  VideoRecorder
//
//  Created by Hyejeong Jeong on 2023/06/10.
//

import CoreData
import UIKit

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
    
    func fetch() -> [VideoInfo]? {
        let fetchRequest = NSFetchRequest<VideoEntity>(entityName: String(describing: VideoEntity.self))
        
        do {
            let fetchedData = try context.fetch(fetchRequest)
            return convertToVideoInfo(from: fetchedData)
        } catch {
            print(error)
            return nil
        }
    }
    
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
    
    func delete(id: UUID) {
        do {
            guard let searchVideo = searchVideo(id: id) else { return }
            
            context.delete(searchVideo)
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private func convertToVideoInfo(from videoEntities: [VideoEntity]) -> [VideoInfo]? {
        var videoInfos = [VideoInfo]()
        
        guard let noImageData = UIImage(systemName: SystemImageName.noThumbnailImage)?.pngData() else { return nil }
        
        videoEntities.forEach {
            let videoInfo = VideoInfo(id: $0.id ?? UUID(),
                                      videoURL: $0.videoURL,
                                      thumbnailImage: $0.thumbnailImage ?? noImageData,
                                      duration: $0.duration,
                                      fileName: $0.fileName ?? "untitle",
                                      registrationDate: $0.registrationDate ?? Date())
            
            videoInfos.append(videoInfo)
        }
        
        return videoInfos
    }
    
    private func searchVideo(id: UUID) -> VideoEntity? {
        let fetchRequest = NSFetchRequest<VideoEntity>(entityName: String(describing: VideoEntity.self))
        let searchCondition = "id == %@"
        
        fetchRequest.predicate = NSPredicate(format: searchCondition, id.uuidString)
        
        do {
            guard let result = try context.fetch(fetchRequest).first else { return nil }
            return result
        } catch {
            print(error)
            return nil
        }
    }
}
