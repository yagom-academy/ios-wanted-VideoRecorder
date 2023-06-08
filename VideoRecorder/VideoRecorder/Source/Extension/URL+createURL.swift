//
//  URL+createURL.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/08.
//

import Foundation

extension URL {
    static func createVideoURL() -> URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let timestamp = Date().timeIntervalSince1970
        let identifier = UUID().uuidString
        let fileName = "recordedVideo_\(timestamp)_\(identifier).mp4"
        let outputURL = documentsDirectory?.appendingPathComponent(fileName)
        
        return outputURL
    }
}
