//
//  VideoListViewModel.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/07.
//

import Photos

final class VideoListViewModel {
    private(set) var fetchedAssets: [PHAsset] = []
    private(set) var videoDataList: [VideoData] = []
    
    private let videoFetchService: VideoAlbumService
    
    init(videoFetchService: VideoAlbumService) {
        self.videoFetchService = videoFetchService
    }
    
    func fetchedAssets(completion: @escaping ([PHAsset]) -> Void) {
        videoFetchService.fetchAssets { [weak self] assets in
            guard let self else { return }
            self.fetchedAssets = assets
            self.configureVideoDataList()
            completion(assets)
        }
    }
    
    private func configureVideoDataList() {
        self.videoDataList = videoFetchService.domainList(from: fetchedAssets)
    }
    
    func deleteVideo(at index: Int) {
        videoDataList.remove(at: index)
        let video = fetchedAssets.remove(at: index)
        videoFetchService.delete(video: video)
    }
}
