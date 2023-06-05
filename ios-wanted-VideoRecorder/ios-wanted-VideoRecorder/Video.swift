//
//  Video.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import AVKit

struct Video: Identifiable {
    let id = UUID()
    var title: String
    var date: Date
    var videoURL: URL?
    
    var image: UIImage? {
        guard let url = videoURL else { return nil }
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        
        assetImgGenerate.appliesPreferredTrackTransform = true
        
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        
        guard let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil) else {
            return nil
        }
        
        let thumbnailImage = UIImage(cgImage: img)
        
        return thumbnailImage
    }
}
