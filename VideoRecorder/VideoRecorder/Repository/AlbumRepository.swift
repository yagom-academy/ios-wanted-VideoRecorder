//
//  AlbumRepository.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/08.
//

import Photos

final class AlbumRepository {
    static let albumName = "VideoRecorderApp"
    
    private var assetCollection: PHAssetCollection?
    
    func saveVideo(at fileURL: URL) {
        guard let assetCollection else {
            return
        }
        
        PHPhotoLibrary.shared().performChanges {
            if let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL),
               let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset,
               let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection) {
                let assets: NSArray = [assetPlaceHolder]
                albumChangeRequest.addAssets(assets)
            }
        }
    }
    
    private func checkAuthorization(completion: @escaping (Bool) -> Void) {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) != .authorized {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] _ in
                self?.checkAuthorization(completion: completion)
            }
        } else if PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized {
            self.createAlbumIfNeeded()
            completion(true)
        } else {
            completion(false)
        }
    }
    
    private func createAlbumIfNeeded() {
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
        } else {
            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: Self.albumName)
            }, completionHandler: { isSuccessed, error in
                if isSuccessed {
                    self.assetCollection = self.fetchAssetCollectionForAlbum()
                } else {
                    print(error ?? "Unexpected result occured while creating PHAssetCollection")
                }
            })
        }
    }
    
    private func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", Self.albumName)
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if collections.firstObject != nil {
            return collections.firstObject
        }
        return nil
    }
}
