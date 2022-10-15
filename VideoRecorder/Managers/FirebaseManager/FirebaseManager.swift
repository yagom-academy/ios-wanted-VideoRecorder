//
//  FirebaseManager.swift
//  VideoRecorder
//
//  Created by CodeCamper on 2022/10/12.
//

import Foundation
import FirebaseStorage
import Combine

protocol FirebaseManagerProtocol {
    /// Firebase Storage에 영상의 업로드를 요청합니다.
    ///
    /// 이 함수는 즉시 반환되며, 영상 업로드는 비동기적으로 진행됩니다.
    /// - Parameter url: 업로드할 영상의 로컬 URL입니다.
    func uploadVideo(_ url: URL)
    
    /// Firebase Storage에서 영상의 삭제를 요청합니다.
    ///
    /// 이 함수는 즉시 반환되며, 영상 삭제는 비동기적으로 진행됩니다.
    /// - Parameter url: 삭제할 영상의 로컬 URL입니다.
    func deleteVideo(_ url: URL)
    
    /// Firebase Storage에서 영상을 다운로드합니다.
    /// - Parameters:
    ///   - url: 영상이 저장될 로컬 URL입니다.
    ///   - completion: 영상 다운로드가 완료된 후, 실행되는 completion입니다.
    func getVideo(_ url: URL, completion: @escaping (Result<URL, Error>) -> ())
}

class FirebaseManager: FirebaseManagerProtocol {
    // MARK: Singleton
    static let shared = FirebaseManager()
    private init() { }
    
    // MARK: Properties
    lazy var storage = Storage.storage()
    
    // MARK: Implementations
    func uploadVideo(_ url: URL) {
        DispatchQueue.global().async {
            let fileRef = self.storage.reference().child(url.lastPathComponent)
            fileRef.putFile(from: url, completion: { _, error in
                if let error = error {
                    debugPrint("😡Firebase Upload Error Occured!😡: \(error)")
                }
            })
        }
    }
    
    func deleteVideo(_ url: URL) {
        DispatchQueue.global().async {
            let fileRef = self.storage.reference().child(url.lastPathComponent)
            fileRef.delete(completion: { error in
                if let error = error {
                    debugPrint("😡Firebase Delete Error Occured!😡: \(error)")
                }
            })
        }
    }
    
    func getVideo(_ url: URL, completion: @escaping (Result<URL, Error>) -> ()) {
        DispatchQueue.global().async {
            let fileRef = self.storage.reference().child(url.lastPathComponent)
            fileRef.write(toFile: url, completion: { firebaseUrl, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                } else if firebaseUrl != nil {
                    DispatchQueue.main.async {
                        completion(.success(url))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(FirebaseManagerError.loadError))
                    }
                }
            })
        }
    }
}
