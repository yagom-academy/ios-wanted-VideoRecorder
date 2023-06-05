//
//  Video.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import AVKit
import SwiftUI

struct Video: Identifiable {
    let id = UUID()
    var title: String
    var date: Date
    var videoURL: URL?
    
    var thumbnailImage: Image {
        guard let url = videoURL else { return Image(systemName: "play.slash.fill") }
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        
        assetImgGenerate.appliesPreferredTrackTransform = true
        
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        
        guard let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil) else {
            return Image(systemName: "play.slash.fill")
        }
        
        let thumbnailImage = UIImage(cgImage: img)
        
        return Image(uiImage: thumbnailImage)
    }
}
