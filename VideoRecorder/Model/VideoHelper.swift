//
//  VideoHelper.swift
//  VideoRecorder
//
//  Created by sole on 2022/10/13.
//

import UIKit
import UniformTypeIdentifiers
import AVKit

enum VideoHelper {
    static func startRecording(delegate: UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera UnAvailable")
            return
        }
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = .camera
        mediaUI.mediaTypes = [UTType.movie.identifier]
        mediaUI.allowsEditing = false
        mediaUI.delegate = delegate
        delegate.present(mediaUI, animated: true)
    }
    
    static func searchingVideoData(from videoURL: URL) -> (date: String, runningTime: String) {
        let asset = AVURLAsset(url: videoURL)
        let duration: CMTime = asset.duration
        let durationSeconds = CMTimeGetSeconds(duration)
        if let date = asset.creationDate?.dateValue {
            return (date.string, durationSeconds.string)
        }
        return ("촬영날짜", durationSeconds.string)
    }
    
    static func generateThumbnail(from videoURL: URL) -> UIImage {
        let cachedKey = NSString(string: videoURL.relativeString)

        if let cachedImage = CacheManager.shared.object(forKey: cachedKey) {
            return cachedImage
        } else {
            do {
                let asset = AVURLAsset(url: videoURL)
                let generator = AVAssetImageGenerator(asset: asset)
                generator.appliesPreferredTrackTransform = true
                let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                CacheManager.shared.setObject(thumbnail, forKey: cachedKey)
                return thumbnail
            } catch {
                print("Fail to generate thumbnail")
                return UIImage(systemName: "video.fill")!
            }
        }
    }
}
