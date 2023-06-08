//
//  VideoListViewModel.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/07.
//

import Photos
import Combine

protocol EventHandleable {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

final class VideoListViewModel: EventHandleable {
    var fetchedAssets: [PHAsset] = []
    
    let videoFetchService: VideoFetchService
    
    init(videoFetchService: VideoFetchService) {
        self.videoFetchService = videoFetchService
    }
    
    func fetchedAssets(completion: @escaping ([PHAsset]) -> Void) {
        videoFetchService.fetchAssets { [weak self] assets in
            guard let self else { return }
            self.fetchedAssets = assets
            completion(assets)
        }
    }
    
    struct Input { }
    struct Output { }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
