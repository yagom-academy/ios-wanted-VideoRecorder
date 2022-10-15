//
//  FileService.swift
//  VideoRecorder
//
//  Created by 권준상 on 2022/10/14.
//

import Foundation
import AVKit

class FileService {

    static let shared = FileService()

    let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    func saveVideo(data: Video) throws {
        let avAsset = AVURLAsset(url: URL(fileURLWithPath: data.videoPath))
        let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)
        let filePath = documentUrl.appendingPathComponent(data.identifier.uuidString + ".mp4")

        exportSession?.outputURL = filePath
        exportSession?.outputFileType = AVFileType.mp4
        exportSession?.shouldOptimizeForNetworkUse = true
       
        exportSession!.exportAsynchronously{
            () -> Void in
            switch exportSession!.status{
            case .failed:
                print("\(exportSession!.error!.localizedDescription)")
            case .cancelled:
                print("Export cancelled")
            case .completed:
                print("Export completed")
            default:
                break
            }
        }
    }

    func deleteFile(_ filePath:URL) {
            guard FileManager.default.fileExists(atPath: filePath.path) else{
                return
            }
            do {
                try FileManager.default.removeItem(atPath: filePath.path)
            }catch{
                fatalError("Unable to delete file: \(error) : \(#function).")
            }
        }
    
    func loadVideoURL(data: VideoModel) -> URL {
        let url = URL(fileURLWithPath: data.identifier.uuidString + ".mp4", relativeTo: documentUrl)
        return url
    }

}
