//
//  ImageFileManager.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/10.
//

import UIKit

final class ImageFileManager {
    static let shared: ImageFileManager = ImageFileManager()
    
    private init() { }
    
    func saveImageToDocumentDirectory(image: CGImage, fileName: String?) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
              let fileName else { return }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        let uiImage = UIImage(cgImage: image)
        
        guard let imageData = uiImage.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        do {
            try imageData.write(to: fileURL)
        } catch {
            return
        }
    }
    
    func loadImageFromDocumentsDirectory(fileName: String) -> UIImage? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        guard let imageData = try? Data(contentsOf: fileURL) else {
            return nil
        }
        
        return UIImage(data: imageData)
    }
}
