//
//  VideoManager.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/06.
//

import Combine
import Foundation

final class VideoManager {
    static let shared = VideoManager()
    
    private let coreDataManager = CoreDataManager.shared
    
    private init() {}
    
    @Published var videoList: [Video] = []
    
    func create(video: Video) {
        if isContains(video) { return }
        
        videoList.append(video)
        coreDataManager.create(type: VideoEntity.self, data: video)
    }
    
    func read() {
        guard let entityList = coreDataManager.read(type: VideoEntity.self) else { return }
        
        videoList = getModels(from: entityList)
    }
    
    func update(video: Video) {
        guard let index = videoList.firstIndex(where: {
            $0.identifier == video.identifier }) else { return }
        
        videoList[index] = video
        coreDataManager.update(type: VideoEntity.self, data: video)
    }
    
    func delete(video: Video) {
        videoList.removeAll {
            $0.identifier == video.identifier
        }
        
        coreDataManager.delete(type: VideoEntity.self, data: video)
    }
}

extension VideoManager {
    private func isContains(_ video: Video) -> Bool {
        return videoList.contains {
            $0.identifier == video.identifier
        }
    }
    
    private func getModels(from entityList: [VideoEntity]) -> [Video] {
        var videoList = [Video]()
        
        entityList.forEach { videoEntity in
            guard let identifier = videoEntity.identifier,
                  let data = videoEntity.data,
                  let title = videoEntity.title,
                  let date = videoEntity.date else { return }
            
            let video = Video(identifier: identifier,
                              data: data,
                              title: title,
                              date: date)
            
            videoList.append(video)
        }
        
        return videoList
    }
}
