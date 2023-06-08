//
//  ViewController.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/05.
//

import UIKit
import Photos

final class VideoListViewController: UIViewController {
    typealias VideoListDataSource = UITableViewDiffableDataSource
    
    enum Section {
        case main
    }
    
    private let tableView = UITableView()
    private var dataSource: VideoListDataSource<Section, VideoData>?
    
    private let imageManager = PHCachingImageManager()
    private let viewModel: VideoListViewModel
    
    init(viewModel: VideoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageSize = CGSize(width: view.bounds.width * 0.25,
                               height: view.bounds.height * 0.125)
        startImageCaching(imageSize: imageSize)
        configureRootView()
        configureNavigationBar()
        
    }
    
    private func startImageCaching(imageSize: CGSize) {
        viewModel.fetchedAssets { [weak self] videoAssets in
            self?.imageManager.startCachingImages(
                for: videoAssets,
                targetSize: imageSize,
                contentMode: .aspectFit,
                options: nil
            )
        }
    }

    private func configureRootView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        let listImage = UIImage(systemName: "list.triangle")
        let titleText = "Video List"
        let listImageView = UIImageView(image: listImage)
        listImageView.tintColor = .black
        let titleLabel = {
            let label = UILabel()
            label.text = titleText
            label.font = .systemFont(ofSize: 24, weight: .heavy)
            label.textColor = .black
            
            return label
        }()
        let stackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.spacing = 8
            
            return stackView
        }()
        
        stackView.addArrangedSubview(listImageView)
        stackView.addArrangedSubview(titleLabel)
        
        let leftBarButtonItem = UIBarButtonItem(customView: stackView)
        
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "video.fill.badge.plus"),
            style: .plain,
            target: self,
            action: #selector(presentRecordingView)
        )
        rightBarButtonItem.tintColor = .systemIndigo
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc
    private func presentRecordingView() {
        let thumbnail = UIImage(systemName: "photo")
        let videoRecordingService = VideoRecordingService(deviceOrientation: .portrait)
        let recordingViewModel = RecordingViewModel(videoRecordingService: videoRecordingService)
        let recordingViewController = RecordingViewController(viewModel: recordingViewModel, thumbnailImage: thumbnail)
        recordingViewController.modalPresentationStyle = .fullScreen
        
        self.present(recordingViewController, animated: true)
    }
    
    private func configureDataSource() {
        
    }
    
    private func requestImage(
        at index: Int,
        size: CGSize,
        resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void
    ) {
        guard let videoAsset = viewModel.fetchedAssets[safe: index] else {
            return
        }
        
        imageManager.requestImage(for: videoAsset,
                                  targetSize: size,
                                  contentMode: .aspectFit,
                                  options: nil,
                                  resultHandler: resultHandler)
    }
}
