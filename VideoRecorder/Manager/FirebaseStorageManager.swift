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

    func uploadVideo(url: URL, fileName: String) {
            do {
                let data = try Data(contentsOf: url)
                print(data.description)
                let storageRef = storage.reference().child(fileName + ".mp4")

                if let uploadData = data as Data? {
                    let metaData = StorageMetadata()
                    metaData.contentType = "video/mp4"
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
                                print("🥳🥳 \(downloadURL)")
                            }
                        }
                    })
                }
            } catch {
                print("uploadData error")
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
