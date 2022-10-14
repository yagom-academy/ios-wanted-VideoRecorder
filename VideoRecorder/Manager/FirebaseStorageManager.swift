//
//  FirebaseStorageManager.swift
//  VideoRecorder
//
//  Created by 김지인 on 2022/10/11.
//

import UIKit
import FirebaseStorage
import Firebase

// TODO : error handling
enum FirebaseError: Error {
    case noVideoData
    case notPutData
    case noDownloadURL
}

final class FirebaseStorageManager {
    
    static let shared = FirebaseStorageManager()
    private let storage = Storage.storage()
    
    func uploadVideo(fileName: String) {
        do {
            let outputFilePath = URL(fileURLWithPath: fileName + ".mp4", relativeTo: FileManager.default.temporaryDirectory)
            let data = try Data(contentsOf: outputFilePath)
            print(data.description)
            let storageRef = storage.reference().child("Videos").child(fileName + ".mov")
            
            if let uploadData = data as Data? {
                let metaData = StorageMetadata()
                metaData.contentType = "mov"
                storageRef.putData(uploadData, metadata: metaData
                                   , completion: { (metadata, error) in
                    if let error = error {
                        print("metadata error: \(error)")
                    } else {
                        storageRef.downloadURL { (url, error) in
                            guard let downloadURL = url else {
                                print("downloadURL error")
                                return
                            }
                            print("😆: \(downloadURL)")
                        }
                    }
                })
            }
        } catch {
            print("uploadData error")
        }
    }
    
    func backupVideo(fileName: String) {
        BackgroundFetch.shared.beginBackgroundTask { (identifier) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                
                self?.uploadVideo(fileName: fileName)
                identifier.endBackgroundTask()
        //                BackgroundFetch.shared.endBackgroundTask(identifier: identifier)
                print("Task Complete")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    print("Task Complete After")
                }
            }
        }
    }
    
    func removeVideo(videoURL: String) {
        let videoRef = storage.reference(forURL: videoURL)
        videoRef.delete { error in
            if let error = error {
                print("Firestore 비디오 삭제 안됨: \(error)")
            } else {
                print("Firestore 비디오 삭제 완료")
            }
        }
    }
    
}
