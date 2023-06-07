//
//  MainViewModel.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import SwiftUI
import Foundation

final class MainViewModel: ObservableObject {
    @Published var videos: [Video] = []
    @Published var isShowCameraView = false {
        didSet {
            searchVideos()
        }
    }
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
        guard let index = videos.firstIndex(where: { $0.id == id }),
              let videoURL = videos[index].videoURL else {
            return
        }
        
        videos.remove(at: index)
        realmManager.delete(id)
        LocalFileURLs.removeVideo(by: videoURL)
    }
}
