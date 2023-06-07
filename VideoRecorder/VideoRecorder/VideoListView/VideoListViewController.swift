//
//  ViewController.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/05.
//

import UIKit

final class VideoListViewController: UIViewController {
    typealias VideoListDataSource = UITableViewDiffableDataSource
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRootView()
        configureNavigationBar()
        
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
}
