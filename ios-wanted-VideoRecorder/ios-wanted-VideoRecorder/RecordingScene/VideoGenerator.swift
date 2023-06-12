//
//  VideoGenerator.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/10.
//
import Foundation

struct VideoGenerator {
    func makeVideo(videoURL: URL, duration: Int) -> VideoEntity? {
        guard let uuid = extractUUID(from: videoURL) else { return nil }
        let videoName = String(uuid.uuidString.suffix(6))
        let videoDuration = Double(duration).format(units: [.minute, .second])
        let thumbnailName = videoName + "image"
        
        return VideoEntity(
            id: uuid,
            name: videoName,
            date: Date(),
            duration: videoDuration ?? "00:00",
            thumbnail: thumbnailName,
            videoURL: videoURL
        )
    }
    
    private func extractUUID(from filePath: URL) -> UUID? {
        let fileName = filePath.lastPathComponent
        let components = fileName.components(separatedBy: ".")
        
        guard components.count >= 2 else { return nil }
        
        return UUID(uuidString: components[0])
    }
}
