//
//  VideoThumbnailService.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/08.
//

import Foundation
import Photos

final class VideoFetchService {
    var repository: AlbumRepository {
        return self.albumRepository
    }
    
    private var videoAssets: [PHAsset] = []
    
    private let albumRepository: AlbumRepository
    
    init(albumRepository: AlbumRepository) {
        self.albumRepository = albumRepository
    }
    
    func fetchAssets(completion: @escaping ([PHAsset]) -> Void) {
        guard let videoCollection = albumRepository.videoCollection else { return }
        
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let fetchResult = PHAsset.fetchAssets(in: videoCollection, options: fetchOption)
        fetchResult.enumerateObjects(options: [.concurrent]) { [weak self] videoAsset, index, cancel in
            guard let self else { return }
            self.videoAssets.append(videoAsset)
        }
        completion(videoAssets)
    }
    
    func assetsToDomainList() -> [VideoData] {
        var videoDataList = videoAssets.map { asset in
            guard let fileName = asset.value(forKey: "fileName") as? String else {
                return VideoData(name: "", creationDate: asset.creationDate)
            }
            return VideoData(name: fileName, creationDate: asset.creationDate)
        }
        
        return videoDataList
    }
}
