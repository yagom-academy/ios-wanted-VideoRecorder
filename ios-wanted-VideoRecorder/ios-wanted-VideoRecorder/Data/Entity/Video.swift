//
//  Video.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import AVKit
import SwiftUI
import RealmSwift

struct Video: Identifiable, Storable {
    
    var id = UUID()
    var title: String
    var date: Date
    var videoURL: URL?
    var videoLength: String
    
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
    
    static func toRealmObject(_ object: Video) -> Object {
        let realmObject = VideoObject()
        
        realmObject.id = object.id
        realmObject.title = object.title
        realmObject.date = object.date
        realmObject.videoURL = object.videoURL
        realmObject.videoLength = object.videoLength
        
        return realmObject
    }
    
    static func toObject(_ object: Object) -> Video? {
        guard let object = object as? VideoObject else { return nil }
        
        let id = object.id
        let title = object.title
        let date = object.date
        let videoURL = object.videoURL
        let videoLength = object.videoLength
        
        return Video(id: id, title: title, date: date, videoURL: videoURL, videoLength: videoLength)
    }
}
