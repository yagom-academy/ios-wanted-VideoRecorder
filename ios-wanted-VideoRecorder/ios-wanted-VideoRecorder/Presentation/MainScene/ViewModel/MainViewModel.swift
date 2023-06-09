//
//  MainViewModel.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import SwiftUI
import Foundation
import AVFoundation

final class MainViewModel: ObservableObject {
    @Published var changeText: String = ""
    @Published var isPresentAlert: Bool = false
    @Published var videos: [Video] = []
    @Published var isShowCameraView = false {
        didSet {
            searchVideos()
        }
    }
    var targetVideo: Video? = nil
    private let dbManager = LocalDBUseCase<VideoObject>()
    
    init() {
        searchVideos()
        
        AVCaptureDevice.requestAccess(for: .video) { _ in }
    }

    func updateTitleVideo() {
        guard let video = targetVideo,
              let index = videos.firstIndex(where: { $0.id == video.id }) else { return }
        
        videos[index].title = changeText
        updateVideoTitle(videos[index])
    }
    
    func deleteVideo(_ indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let video = videos[index]

        videos.remove(at: index)
        dbManager.delete(video.id)
        
        guard let videoURL = video.videoURL else { return }
        
        LocalFileURLs.removeVideo(by: videoURL)
    }
    
    private func searchVideos() {
        guard let realmObjects = dbManager.read() else { return }
        
        let videos = realmObjects.compactMap { object in
            return Video.toObject(object)
        }
        
        self.videos = videos.sorted { $0.date > $1.date }
    }
    
    private func updateVideoTitle(_ video: Video) {
        guard let newVideo = Video.toRealmObject(video) as? VideoObject else {
            return
        }
        dbManager.update(newVideo)
    }
}
