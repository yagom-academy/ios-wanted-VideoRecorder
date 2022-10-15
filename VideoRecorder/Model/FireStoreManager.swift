//
//  FireStoreManager.swift
//  VideoRecorder
//
//  Created by 권준상 on 2022/10/14.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class FireStoreManager {
    
    private var documentListener: ListenerRegistration?
    
    func save(_ video: Video, completion: ((Error?) -> Void)? = nil) {
        let collectionListener = Firestore.firestore().collection("user")
        
        guard let dictionary = video.asDictionary else {
            print("decode error")
            return
        }
        collectionListener.document("\(video.identifier)").setData(dictionary) { error in
            completion?(error)
        }
    }

    func subscribe(completion: @escaping (Result<[Video], FireStoreError>) -> Void) {
        let collectionListener = Firestore.firestore().collection("user")
        removeListener()
        
        documentListener = collectionListener
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else {
                    completion(.failure(FireStoreError.error))
                    return
                }
                
                var videos = [Video]()
                snapshot.documentChanges.forEach { change in
                    switch change.type {
                    case .added, .modified:
                        do {
                            let video = try change.document.data(as:Video.self)
                            videos.append(video)
                        } catch {
                            completion(.failure(FireStoreError.error))
                        }
                    default: break
                    }
                }
                completion(.success(videos))
            }
    }
    
    func delete(_ video: VideoModel) {
        let collectionListener = Firestore.firestore().collection("user")
        collectionListener.document("\(video.identifier)").delete() { err in
            if let err = err {
                print("Error removing document: \(err.localizedDescription)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func removeListener() {
        documentListener?.remove()
    }
}

enum FireStoreError: Error {
    case error
}
