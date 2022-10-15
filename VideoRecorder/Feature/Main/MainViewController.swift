//
//  MainViewController.swift
//  VideoRecorder
//
//  Created by kjs on 2022/10/07.
//

import UIKit
import AVFoundation
import Photos

class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var naviBarList: UIBarButtonItem!
    
    let dateFormatter = DateFormatter()
    var fetchingMore = false
    var hasNextPage = false
    var count = 6
    
    let navibar: UIButton = {
        let navibar = UIButton()
        navibar.image(for: .normal)
        return navibar
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Video List"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return titleLabel
    }()
    
    var fetchResult : PHFetchResult<PHAsset>!
    let imageManager : PHCachingImageManager = PHCachingImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBarList.tintColor = .black
        photoAurthorizationStatus()
    }
    //PHAsset콜렉션 비디오타입만
    func requestColltion() {
        let cameraRoll : PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumVideos, options: nil)
        guard let cameraRollCollection = cameraRoll.firstObject else {
            return
        }
        //PHAsset 옵션
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 6
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
        
        
        print(#function, self.fetchResult.count)
    }
    
    
    //PHAsset접근
    func photoAurthorizationStatus() {
        let photo_aurthorization_status = PHPhotoLibrary.authorizationStatus()
        switch photo_aurthorization_status {
        case .authorized :
            print("접근 허가됨")
            self.requestColltion()
        case .denied :
            print("접근 불허")
        case .notDetermined:
            print("아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization({(status) in
                switch status{
                case .authorized:
                    print("사용자가 허용함")
                    self.requestColltion()
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                    }
                case .denied:
                    print("사용자가 불허함")
                default : break
                }
            })
        case .restricted:
            print("접근 제한")
        default : break
        }
        PHPhotoLibrary.shared().register(self)
    }
    
    @IBAction func didTapCameraButton(_ sender: UIBarButtonItem) {
        checkAuthorization()
    }
    
    // 카메라 권한 확인
    func checkAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.checkAudioAuthorization()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.checkAudioAuthorization()
                }
            }
        case .denied:
            return
        case .restricted:
            return
        @unknown default:
            return
        }
    }
    
    func checkAudioAuthorization() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                self.presentCameraViewController()
            }
        }
    }
    
    // 카메라 뷰 컨트롤러로 이동
    func presentCameraViewController() {
        DispatchQueue.main.async {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: CameraViewController.identifier) else { return }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}
//테이블뷰 설정
extension MainViewController: UITableViewDelegate, UITableViewDataSource,PHPhotoLibraryChangeObserver {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    //테이블셀섹션정의
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return fetchResult.count
        } else if section == 1 && fetchingMore && hasNextPage {
            return 1
        }
        return 0
    }
    //테이블셀 정의
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath) as? VideoTableViewCell else {return UITableViewCell()}
            
            let asset : PHAsset = fetchResult.object(at: indexPath.row)
            let resource = PHAssetResource.assetResources(for: asset)
            let filename = resource.first?.originalFilename ?? "unknown"
           
           //저화질로 보여준다
            imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit , options: nil, resultHandler: {image, _ in cell.videoImage.image = image})
            
            //고화질로 보여준다.(isSynchronous = false 라 비동기방식)
            cell.videoImage.image = assetToImage(asset: asset)
                func assetToImage(asset: PHAsset) -> UIImage {
                    var image = cell.videoImage.image
                        let manager = PHImageManager.default()
                        let options = PHImageRequestOptions()
                    options.deliveryMode = .highQualityFormat
                    options.isSynchronous = false
                        
                        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: options, resultHandler: {(result, info)->Void in
                            image = result!
                        })
                    return image ?? UIImage()
                    }
            
            cell.videoName.text = "\(filename)"
            //에셋 동영상 날짜 포멧
            dateFormatter.dateFormat = "yyyy-MM-dd"
            cell.currentDate.text = dateFormatter.string(from: asset.creationDate ?? Date())
            cell.videoTime.text = "\(timeString(time: asset.duration))"
            return cell
        } else {
            
            if indexPath.section == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "LodingTableViewCell", for: indexPath) as? LodingTableViewCell else {return UITableViewCell()}
                cell.start()
                return cell
            }
        }
        return UITableViewCell()
    }
    //셀 동적높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    //스와이프로삭제버튼
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("시스템 : \(editingStyle)")
        if editingStyle == .delete {
            let asset : PHAsset = self.fetchResult[indexPath.row]
            PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets([asset] as NSArray)}, completionHandler: nil)
        }
        print("시스템 : editingStyle", #function)
    }
    // 동영상시간 변환
    func timeString(time: TimeInterval) -> String {
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60

        if hour == 0 && minute == 0 {
            return String(format: "%01i:%02i", minute, second)
        }else if hour == 0 && minute != 0 {
            return String(format: "%02i:%02i", minute, second)
        }
        return String(format: "%01i:%02i:%02i", hour, minute, second)
    }
    
    //삭제시 테이블셀 정렬
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        print("시스템 : ",#function)
        guard let changes = changeInstance.changeDetails(for: fetchResult)
        else { return }
        fetchResult = changes.fetchResultAfterChanges
        OperationQueue.main.addOperation {
            self.tableView.reloadSections(IndexSet(0...1), with: .automatic)
        }
    }
    // 셀선택시 동영상재생할세번째 뷰
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // let data = fetchResult[indexPath.row]
        
        let options: PHVideoRequestOptions = PHVideoRequestOptions()
        options.version = .original
        PHImageManager.default().requestAVAsset(forVideo: fetchResult.object(at: indexPath.row), options: options) { asset, audio, info in
            if let urlAsset = asset as? AVURLAsset {
                let fileURL = urlAsset.url
                
                self.pushMediaViewController(asset: asset, fileURL: fileURL)
            }
        }
    }
    
    func pushMediaViewController(asset: AVAsset?, fileURL: URL) {
        DispatchQueue.main.async {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: MediaViewController.identifier) as? MediaViewController else { return }
            guard let asset = asset else { return }
            vc.videoModel = VideoModel(time: asset.duration, fileURL: fileURL)
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //스크롤뷰를 생성하여 Pagination 구현
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height {
            if !fetchingMore {
                count += 6
                beginBatchFetch()
            }
        }
    }
    // 마지막셀이 스크롤 마지막에 도달했을때 실행될 함수
    func beginBatchFetch() {
        print(fetchResult.count)

        fetchingMore = true
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            let cameraRoll : PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumVideos, options: nil)
            guard let cameraRollCollection = cameraRoll.firstObject else {
                return
            }
            let fetchOptions = PHFetchOptions()
            fetchOptions.fetchLimit = self.count
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
            self.hasNextPage = self.fetchResult.count > self.count ? false : true
            self.fetchingMore = false
            self.tableView.reloadData()
        })
    }
}

