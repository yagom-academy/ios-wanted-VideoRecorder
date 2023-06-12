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
    
    var albumRepository: AlbumRepository {
        return videoFetchService.albumRepository
    }
    
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
    
    func getFileURL(at index: Int, completion: @escaping (URL?) -> Void) {
        guard let asset = fetchedAssets[safe: index] else { return }
        
        let options = PHVideoRequestOptions()
        options.version = .original
        
        PHImageManager.default().requestAVAsset(
            forVideo: asset,
            options: options
        ) { asset, _, _ in
            if let urlAsset = asset as? AVURLAsset {
                let localVideoUrl = urlAsset.url as URL
                completion(localVideoUrl)
            } else {
                completion(nil)
            }
        }
    }
}
