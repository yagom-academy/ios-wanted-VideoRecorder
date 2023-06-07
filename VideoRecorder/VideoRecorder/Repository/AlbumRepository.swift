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
    
    init() {
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }

        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { _ in }
        }
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            self.createAlbum()
        } else {
            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: requestAuthorizationHandler)
        }
    }
    
    func saveVideo(at fileURL: URL) {
        guard let assetCollection else { return }
        
        PHPhotoLibrary.shared().performChanges {
            if let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL),
               let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset,
               let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection) {
                let assets: NSArray = [assetPlaceHolder]
                albumChangeRequest.addAssets(assets)
            }
        }
    }
    
    private func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            self.createAlbum()
        } else {
            print("not authorized")
        }
    }
    
    private func createAlbum() {
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
    
    private func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", Self.albumName)
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let _: AnyObject = collections.firstObject {
            return collections.firstObject
        }
        
        return nil
    }
}
