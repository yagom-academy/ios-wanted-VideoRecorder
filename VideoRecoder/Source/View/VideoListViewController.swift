//
//  VideoListViewController.swift
//  VideoRecoder
//
//  Created by kimseongjun on 2023/06/05.
//

import UIKit

class VideoListViewController: UIViewController {
    private enum Section: CaseIterable {
        case main
    }
    private let videoListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    private var dataSource: UITableViewDiffableDataSource<Section, Video>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(videoListTableView)
        
        NSLayoutConstraint.activate([
            videoListTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            videoListTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            videoListTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            videoListTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func configureDataSource() {
        videoListTableView.register(VideoListCell.self, forCellReuseIdentifier: VideoListCell.identifier)
        
        dataSource = UITableViewDiffableDataSource<Section, Video>(tableView: videoListTableView, cellProvider: { tableView, indexPath, video in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: VideoListCell.identifier, for: indexPath) as? VideoListCell
            
            cell?.configureCell(video: video)
            
            return cell
            
        })
    }
    
    private func applySnapshot(videos: [Video]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Video>()
        snapshot.appendSections([.main])
        snapshot.appendItems(videos)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}


