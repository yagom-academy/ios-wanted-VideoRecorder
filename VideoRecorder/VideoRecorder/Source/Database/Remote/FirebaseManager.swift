//
//  FirebaseManager.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/10.
//

import Foundation
import FirebaseStorage
import UIKit

final class FirebaseManager {
    enum Path {
        static let video = "Videos"
    }
    
    static let shared = FirebaseManager()
    
    private let codeManager = CodeManager()
    private let storage = Storage.storage()
    private var storageReference: StorageReference {
        storage.reference(withPath: Path.video)
    }
    
    private init() {}
    
    func upload<DTO: DataTransferObject & Codable>(model: DTO, fileName: String) {
        guard let data = codeManager.encode(model) else { return }
        
        let uploadReference = storageReference.child("\(fileName)-\(model.identifier.uuidString)")
        let uploadTask = uploadReference.putData(data)
        
        DispatchQueue.global(qos: .background).async {
            uploadTask.enqueue()
        }
    }
    
    func download() {
    }
    
    func delete<DTO: DataTransferObject & Codable>(model: DTO, fileName: String) {
        let deleteReference = storageReference.child("\(fileName)-\(model.identifier.uuidString)")
        
        deleteReference.delete { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
}
