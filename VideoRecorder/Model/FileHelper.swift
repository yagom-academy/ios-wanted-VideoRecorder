//
//  FileHelper.swift
//  VideoRecorder
//
//  Created by sole on 2022/10/14.
//

import UIKit

final class FileHelper {
    static let shared = FileHelper()
    
    private let manager: FileManager
    private let documentPath: URL
    private let filePath: URL
    
    private init() {
        self.manager = FileManager.default
        self.documentPath = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.filePath = documentPath.appendingPathComponent("RecordVideo")
    }
    
    func getImagePath(from image: UIImage) throws -> String {
        if !manager.fileExists(atPath: filePath.relativePath) {
            try manager.createDirectory(at: filePath, withIntermediateDirectories: false)
        }
        let imageName = UUID().uuidString
        let imagePath = filePath.appendingPathComponent("\(imageName).jpeg")
        
        // save
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try jpegData.write(to: imagePath)
        }
        return imagePath.relativePath
    }
}
