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

class FirebaseStorageManager {
    
    static func uploadVideo(videoData: Data?, completion: @escaping (URL?) -> Void) {
        let reference = Storage.storage().reference()
        guard let video = videoData else { return completion(nil) }
        reference.putData(video, metadata: nil) { metadata, error in
            if let error = error {
                fatalError("Firebase Storage 저장 안됨: \(error)")
            }
            reference.downloadURL { url, erro in
                guard let downloadURL = url else {
                    completion(nil)
                    return
                }
                completion(downloadURL.absoluteURL)
            }
        }
       
    }
    
    static func removeVideo(videoURL: String) {
        let videoRef = Storage.storage().reference(forURL: videoURL)
        videoRef.delete { error in
            if let error = error {
                print("Firestore 비디오 삭제 안됨: \(error)")
            } else {
                print("Firestore 비디오 삭제 완료")
            }
        }
    }

}
