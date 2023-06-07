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
        
        self.videos = videos.sorted { $0.date > $1.date }
    }
    
    func deleteVideo(_ indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let video = videos[index]

        videos.remove(at: index)
        realmManager.delete(video.id)
        
        guard let videoURL = video.videoURL else { return }
        
        LocalFileURLs.removeVideo(by: videoURL)
    }
}
