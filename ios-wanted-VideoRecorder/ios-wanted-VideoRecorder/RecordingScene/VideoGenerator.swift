//
//  VideoGenerator.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/10.
//
import Foundation

struct VideoGenerator {
    func makeVideo(videoURL: URL, duration: String, imageData: Data) -> VideoEntity? {
        guard let uuid = extractUUID(from: videoURL) else { return nil }
        let tempVideoName = String(uuid.suffix(6))
        
        
        return nil
    }
    
    private func extractUUID(from filePath: URL) -> String? {
        let fileName = filePath.lastPathComponent
        let components = fileName.components(separatedBy: ".")
        
        guard components.count >= 2 else { return nil }
        
        return components[0]
    }
    
    func makeVideoName() {
        
    }
}
