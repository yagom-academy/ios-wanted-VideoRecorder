//
//  RecordFileManger.swift
//  VideoRecorder
//
//  Created by 김지인 on 2022/10/13.
//

import Foundation

final class RecordFileManger {
    
    static let shared = RecordFileManger()
    private let fileManager = FileManager.default
    private let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    func createVideoName() -> String {
        return String(Date().timeIntervalSince1970) + UUID().uuidString
    }
    
    func createVideoFile(videoName: String) -> URL {
        let fileURL = documentsURL.appendingPathComponent(videoName).appendingPathExtension("mp4")
        return fileURL
    }
  
    func fileInDirectoryURL(fileName: String) -> URL {
        guard let url = URL(string: documentsURL.appendingPathComponent(fileName).path) else { return URL(fileURLWithPath: "") }
        return url
    }
    
    private func fileExistAtPath(path: String) -> Bool {
        return fileManager.fileExists(atPath: path)
    }
    
    
}

