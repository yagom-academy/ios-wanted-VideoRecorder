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
    
    private var dataSource: UITableViewDiffableDataSource<Section, VideoInfo>?
    
    private let videoListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(VideoListCell.self, forCellReuseIdentifier: VideoListCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let videos: [VideoInfo] = [
        VideoInfo(videoURL: URL(string: "www.naver.com")!, thumbnailImageName: UIImage(named: "Sample")!, duration: 0.3, fileName: "file1.mp4", registrationDate: Date())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(String(describing: VideoEntity.self))
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
        dataSource = UITableViewDiffableDataSource<Section, VideoInfo>(tableView: videoListTableView) {
            [weak self] (tableView, indexPath, video) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoListCell.identifier) as? VideoListCell else {
                return UITableViewCell()
            }

            let contents = self?.videos[indexPath.row]
//            cell.configure(thumbnailImageName: contents?.thumbnailImageName ?? "",
//                           playbackTime: contents?.duration ?? "",
//                           fileName: contents?.fileName ?? "",
//                           date: contents?.registrationDate.translateLocalizedFormat() ?? "")
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, VideoInfo>()
        snapshot.appendSections([.main])
        snapshot.appendItems([VideoInfo(videoURL: URL(string: "www.naver.com")!, thumbnailImageName: UIImage(named: "Sample")!, duration: 0.3, fileName: "file1.mp4", registrationDate: Date())], toSection: .main)
        dataSource?.apply(snapshot)
    }
}
