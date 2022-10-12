//
//  VideoListViewController.swift
//  VideoRecorder
//
//  Created by kjs on 2022/10/07.
//

import UIKit

final class VideoListViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(VideoListCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private var dataSource: UITableViewDiffableDataSource<Section, Video>!
    
    var videoList: [Video] = [
        Video(name: "Naure", thumbnail: UIImage(named: "sample")!, runningTime: "3:21", date: "2022-09-22"),
        Video(name: "Food", thumbnail: UIImage(named: "sample")!, runningTime: "1:03:21", date: "2022-09-22"),
        Video(name: "Buliding", thumbnail: UIImage(named: "sample")!, runningTime: "57:21", date: "2022-09-22"),
        Video(name: "Concert", thumbnail: UIImage(named: "sample")!, runningTime: "3:21", date: "2022-09-22"),
        Video(name: "Bridge", thumbnail: UIImage(named: "sample")!, runningTime: "32:21", date: "2022-09-22"),
        Video(name: "Naure", thumbnail: UIImage(named: "sample")!, runningTime: "3:21", date: "2022-09-22"),
        Video(name: "Food", thumbnail: UIImage(named: "sample")!, runningTime: "1:03:21", date: "2022-09-22"),
        Video(name: "Buliding", thumbnail: UIImage(named: "sample")!, runningTime: "57:21", date: "2022-09-22"),
        Video(name: "Concert", thumbnail: UIImage(named: "sample")!, runningTime: "3:21", date: "2022-09-22"),
        Video(name: "Bridge", thumbnail: UIImage(named: "sample")!, runningTime: "32:21", date: "2022-09-22"),
        Video(name: "Naure", thumbnail: UIImage(named: "sample")!, runningTime: "3:21", date: "2022-09-22"),
        Video(name: "Food", thumbnail: UIImage(named: "sample")!, runningTime: "1:03:21", date: "2022-09-22"),
        Video(name: "Buliding", thumbnail: UIImage(named: "sample")!, runningTime: "57:21", date: "2022-09-22"),
        Video(name: "Concert", thumbnail: UIImage(named: "sample")!, runningTime: "3:21", date: "2022-09-22"),
        Video(name: "Bridge", thumbnail: UIImage(named: "sample")!, runningTime: "32:21", date: "2022-09-22"),
    ]

    private let navigationLeftBarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "list.triangle"), for: .normal)
        button.tintColor = Color.label
        
        button.setTitle("  Video List", for: .normal)
        button.titleLabel?.font = Font.title3
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setTitleColor(Color.label, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.systemBackground
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        configureDataSource()
        performQuery()
        configureNavigation()
    }
    
    private func configureNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationLeftBarButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "video.fill.badge.plus"), style: .plain, target: self, action: .none)
        navigationItem.rightBarButtonItem?.tintColor = Color.purple
    }
    
//    private func createBasicListLayout() -> UICollectionViewLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                              heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                              heightDimension: .absolute(630))
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
//                                                         subitem: item, count: 7)
//        let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [group])
//        let section = NSCollectionLayoutSection(group: containerGroup)
//        section.orthogonalScrollingBehavior = .paging
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        return layout
//    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Video>(tableView: self.tableView) { tableView, indexPath, video in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? VideoListCell else { return UITableViewCell() }
            
            cell.videoNameLabel.text = video.name
            cell.thumbnailImageView.image = video.thumbnail
            cell.runningTimeLabel.text = video.runningTime
            cell.dateLabel.text = video.date
            
            return cell
        }
    }
    
    private func performQuery() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Video>()
        snapshot.appendSections([.main])
        snapshot.appendItems(videoList)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

