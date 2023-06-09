//
//  VideoListViewController.swift
//  VideoRecorder
//
//  Created by Hyejeong Jeong on 2023/06/05.
//

import UIKit

final class VideoListViewController: UIViewController {
    enum Section {
        case main
    }
    
    private var dataSource: UITableViewDiffableDataSource<Section, Video>?
    
    private let videoListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(VideoListCell.self, forCellReuseIdentifier: VideoListCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let videos: [Video] = [
        Video(thumbnailImageName: "sample", playbackTime: "1:13:01", fileName: "file1.mp4", registrationDate: Date()),
        Video(thumbnailImageName: "sample", playbackTime: "3:01", fileName: "file2.mp4", registrationDate: Date()),
        Video(thumbnailImageName: "sample", playbackTime: "13:01", fileName: "file3.mp4", registrationDate: Date()),
        Video(thumbnailImageName: "sample", playbackTime: "55:01", fileName: "file4.mp4", registrationDate: Date()),
        Video(thumbnailImageName: "sample", playbackTime: "12:03:01", fileName: "file5.mp4", registrationDate: Date()),
        Video(thumbnailImageName: "sample", playbackTime: "3:01", fileName: "file6.mp4", registrationDate: Date()),
        Video(thumbnailImageName: "sample", playbackTime: "3:01", fileName: "file7.mp4", registrationDate: Date()),
        Video(thumbnailImageName: "sample", playbackTime: "3:01", fileName: "file8.mp4", registrationDate: Date()),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIOption()
        configureVideoListTableView()
        configureDataSource()
        applySnapshot()
    }
    
    private func configureUIOption() {
        let rightBarButtonIcon = UIImage(systemName: SystemImageName.addedVideo)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.systemIndigo)
        
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: VideoListTitleView())
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarButtonIcon,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(pushAddVideoViewController))
    }
    
    @objc private func pushAddVideoViewController() {
        let addVideoViewController = AddVideoViewController()
        navigationController?.pushViewController(addVideoViewController, animated: true)
    }
    
    private func configureVideoListTableView() {
        view.addSubview(videoListTableView)
        
        videoListTableView.dataSource = dataSource
        
        NSLayoutConstraint.activate([
            videoListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            videoListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            videoListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            videoListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Video>(tableView: videoListTableView) {
            [weak self] (tableView, indexPath, video) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoListCell.identifier) as? VideoListCell else {
                return UITableViewCell()
            }
            
            let contents = self?.videos[indexPath.row]
            cell.configure(thumbnailImageName: contents?.thumbnailImageName ?? "",
                           playbackTime: contents?.playbackTime ?? "",
                           fileName: contents?.fileName ?? "",
                           date: contents?.registrationDate.translateLocalizedFormat() ?? "")
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Video>()
        snapshot.appendSections([.main])
        snapshot.appendItems(videos, toSection: .main)
        dataSource?.apply(snapshot)
    }
}
