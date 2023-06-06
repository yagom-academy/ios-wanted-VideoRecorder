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
    
    private var dataSource: UITableViewDiffableDataSource<Section, Video>!
    
    private let leftBarItemStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let titleIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "list.triangle")
        imageView.tintColor = .black
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Video List"
        label.font = UIFont.preferredFont(forTextStyle: .title1, compatibleWith: UITraitCollection(legibilityWeight: .bold))
        
        return label
    }()
    
    private let addVideoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "video.fill.badge.plus"), for: .normal)
        button.tintColor = .purple
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let videoListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        configureLeftBarItem()
        configureRightBarItem()
    }
    
    private func configureLeftBarItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarItemStackView)
        
        leftBarItemStackView.addArrangedSubview(titleIconView)
        leftBarItemStackView.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleIconView.widthAnchor.constraint(equalToConstant: 30),
            titleIconView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }
    
    private func configureRightBarItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: addVideoButton)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
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
        
        dataSource = UITableViewDiffableDataSource<Section, Video>(
            tableView: videoListTableView,
            cellProvider: { tableView, indexPath, video in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: VideoListCell.identifier, for: indexPath) as? VideoListCell
            
            cell?.configureCell(video: video)
            
            return cell
            }
        )
    }
    
    private func applySnapshot(videos: [Video]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Video>()
        snapshot.appendSections([.main])
        snapshot.appendItems(videos)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
