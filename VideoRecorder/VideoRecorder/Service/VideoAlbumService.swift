//
//  VideoThumbnailService.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/08.
//

import Foundation
import Photos

final class VideoAlbumService {
    let albumRepository: AlbumRepository
    private let dateFormatter: DateFormatter
    
    init(albumRepository: AlbumRepository, dateFormatter: DateFormatter) {
        self.albumRepository = albumRepository
        self.dateFormatter = dateFormatter
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
            
            guard let fileName = resource.first?.originalFilename,
                  let date = asset.creationDate else {
                return VideoData(name: "", creationDate: "")
            }
            let dateString = dateFormatter.string(from: date)
            
            return VideoData(name: fileName, creationDate: dateString)
        }
        
        return videoDataList
    }
    
    func delete(video: PHAsset) {
        albumRepository.delete(video: video)
    }
}
