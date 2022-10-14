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
    
    static func SearchingVideoData(from videoURL: URL) -> (date: String, runningTime: String) {
        let asset = AVURLAsset(url: videoURL)
        let duration: CMTime = asset.duration
        let durationSeconds = CMTimeGetSeconds(duration)
        if let date = asset.creationDate?.dateValue {
            return (date.string, durationSeconds.string)
        }
        return ("촬영날짜", durationSeconds.string)
    }
    
    static func generateThumbnail(from videoURL: String) throws -> UIImage {
        guard let url = URL(string: videoURL) else { return UIImage() }
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
        let thumbnail = UIImage(cgImage: cgImage)
        return thumbnail
    }
}
