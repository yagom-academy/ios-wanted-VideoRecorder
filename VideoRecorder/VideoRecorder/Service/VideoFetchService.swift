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
    
    private let albumRepository: AlbumRepository
    
    init(albumRepository: AlbumRepository) {
        self.albumRepository = albumRepository
    }
    
    func fetchAssets(completion: @escaping ([PHAsset]) -> Void) {
        guard let videoCollection = albumRepository.videoCollection else { return }
        
        var videoAssets: [PHAsset] = []
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let fetchResult = PHAsset.fetchAssets(in: videoCollection, options: fetchOption)
        fetchResult.enumerateObjects(options: [.concurrent]) { videoAsset, index, cancel in
            videoAssets.append(videoAsset)
        }
        completion(videoAssets)
    }
    
    func domainList(from videoAssets: [PHAsset]) -> [VideoData] {
        let videoDataList = videoAssets.map { asset in
            let resource = PHAssetResource.assetResources(for: asset)
            
            guard let fileName = resource.first?.originalFilename else {
                return VideoData(name: "", creationDate: asset.creationDate)
            }
            return VideoData(name: fileName, creationDate: asset.creationDate)
        }
        
        return videoDataList
    }
}
