//
//  FirebaseStorageManager.swift
//  VideoRecorder
//
//  Created by 김지인 on 2022/10/11.
//

import UIKit
import FirebaseStorage
import Firebase

class FirebaseStorageManager {
    
    static func uploadVideo(videoData: Data, pathRoot: String, completion: @escaping (URL?) -> Void) {
        let metaData = StorageMetadata()
        metaData.contentType = "video/mp4"
        let videoName = UUID().uuidString + String(Date().timeIntervalSince1970)
        let firebaseRef = Storage.storage().reference().child("\(videoName)")
        firebaseRef.putData(videoData, metadata: nil) { (metadata, error) in
            firebaseRef.downloadURL { url, error in
                completion(url)
            }
        }
    }
    
    static func downloadVideo(urlString: String, completion: @escaping (Data?) -> Void) {
        let storageRef = Storage.storage().reference(forURL: urlString)
        let megaByte = Int64(1 * 1024 * 1024)
        storageRef.getData(maxSize: megaByte) { data, error in
            guard let videoData = data else {
                completion(nil)
                print("비디오가 없음")
                return
            }
            completion(videoData)
        }
    }
}
