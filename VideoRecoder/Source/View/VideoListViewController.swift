//
//  ViewController.swift
//  VideoRecoder
//
//  Created by kimseongjun on 2023/06/05.
//

import UIKit

class VideoListViewController: UIViewController {
    private enum Section: CaseIterable {
        case main
    }
    private let videoListTableView = UITableView()
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
}

