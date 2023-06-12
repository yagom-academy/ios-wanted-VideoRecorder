//
//  ThumbnailManager.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/10.
//

import UIKit
import AVFoundation

final class ThumbnailManager {
    func generateThumbnail(for data: Data?, completion: @escaping (UIImage?) -> Void) {
        guard let videoURL = createVideoURL(with: data) else { return }
        
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        let firstCutTime = CMTime(value: 0, timescale: 1)
        
        imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: firstCutTime)]) {
            requestedTime, thumbnail, actualTime, result, error in
            if let error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let thumbnail else {
                completion(nil)
                return
            }

            let image = UIImage(cgImage: thumbnail)
            completion(image)
        }
    }
    
    func getVideoPlayTime(for data: Data?) -> String? {
        guard let videoURL = createVideoURL(with: data) else { return nil }
        
        let asset = AVAsset(url: videoURL)
        let playTime = asset.duration
        
        return playTime.formattedTime
    }
    
    private func createVideoURL(with data: Data?) -> URL? {
        guard let data else { return nil }
        
        let temporaryURL = FileManager.default.temporaryDirectory
        let fileName = "\(UUID().uuidString).mp4"
        let videoURL = temporaryURL.appendingPathComponent(fileName)
        
        do {
            try data.write(to: videoURL)
            return videoURL
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
