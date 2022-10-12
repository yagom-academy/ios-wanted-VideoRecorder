//
//  RecordFileManger.swift
//  VideoRecorder
//
//  Created by 김지인 on 2022/10/13.
//

import Foundation

class RecordFileManger {
    static let shared = RecordFileManger()
    let fileManager = FileManager.default
    let folderName = "VideoRecoder"
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
//    func createFolder() {
//        let filePath = documentsURL.appendingPathComponent("\(folderName)")
//        if !fileManager.fileExists(atPath: filePath.path) {
//            do {
//                try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true)
//            } catch let e {
//                print(e.localizedDescription)
//            }
//        }
//    }
    
    func createVideoFile() -> URL {
        let videoName = String(Date().timeIntervalSince1970) + UUID().uuidString
        let fileURL = documentsURL.appendingPathComponent("\(folderName)").appendingPathComponent(videoName).appendingPathExtension("mov")
        return fileURL
    }
  
    
    func fileInDocumentDirectory(fileName: String) -> String {
        return documentsURL.appendingPathComponent(fileName).path
    }
    
    func fileExistAtPath(path: String) -> Bool {
        return fileManager.fileExists(atPath: path)
    }
    
    
}

