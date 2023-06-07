//
//  MainViewModel.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import Combine
import Foundation

final class MainViewModel: ObservableObject {
    @Published var videos: [Video] = []
    private let realmManager = RealmManager<VideoObject>()
    
    init() {
        searchVideos()
    }
    
    private func searchVideos() {
        guard let realmObjects = realmManager.read() else { return }
        
        let videos = realmObjects.compactMap { object in
            return Video.toObject(object)
        }
        
        self.videos = videos
    }
    
    func deleteVideo(_ id: UUID) {
        guard let index = videos.firstIndex(where: { video in
            return video.id == id
        }) else {
            return
        }
        let video = videos[index]
        videos.remove(at: index)
        
        guard let videoObject = Video.toRealmObject(video) as? VideoObject else { return }
        
        realmManager.delete(videoObject)
    }
}
