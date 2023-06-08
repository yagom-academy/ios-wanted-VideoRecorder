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
    
    private let videoFetchService: VideoFetchService
    private let dateFormatter: DateFormatter
    
    init(videoFetchService: VideoFetchService, dateFormatter: DateFormatter) {
        self.videoFetchService = videoFetchService
        self.dateFormatter = dateFormatter
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
    
    func convertToString(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        return dateFormatter.string(from: date)
    }
}
