//
//  VideoListViewController.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/07.
//

import UIKit

final class VideoListViewController: UIViewController {
    private enum Section: Hashable {
        case videos
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Video.ID>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Video.ID>
    
    private lazy var videoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewListLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: VideoCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private var dataSource: DataSource?
    
    private let videoList: [Video] = [
        Video(name: "mcok", fileExtension: "mp4", date: Date(), url: "www.what.com", duration: "32:24"),
        Video(name: "mcok", fileExtension: "mp4", date: Date(), url: "www.what.com", duration: "32:24"),
        Video(name: "mcok", fileExtension: "mp4", date: Date(), url: "www.what.com", duration: "32:24"),
        Video(name: "mcok", fileExtension: "mp4", date: Date(), url: "www.what.com", duration: "32:24"),
        Video(name: "mcok", fileExtension: "mp4", date: Date(), url: "www.what.com", duration: "32:24"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRootView()
        configureNavigationBar()
        configureLayout()
        configureDataSource()
        applySnapshot()
    }
    
    private func configureRootView() {
        view.backgroundColor = .white
        view.addSubview(videoCollectionView)
    }
    
    private func configureNavigationBar() {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .default)
        let leftButton = UIButton()
        leftButton.tintColor = .black
        leftButton.setImage(
            UIImage(systemName: "list.triangle", withConfiguration: config),
            for: .normal
        )
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        titleLabel.text = "Video List"
        
        let stackView = UIStackView(arrangedSubviews: [leftButton, titleLabel])
        stackView.spacing = 5
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: stackView)

        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "video.fill.badge.plus", withConfiguration: config),
            style: .plain,
            target: self,
            action: #selector(presentRecordingScene)
        )
        rightBarButtonItem.tintColor = .systemBlue
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func configureLayout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            videoCollectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            videoCollectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            videoCollectionView.topAnchor.constraint(equalTo: safe.topAnchor),
            videoCollectionView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: videoCollectionView, cellProvider: cellProvider)
    }
    
    private func cellProvider(_ collectionView: UICollectionView, indexPath: IndexPath, identifier: Video.ID) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: VideoCell.identifier,
            for: indexPath
        ) as? VideoCell
        
        cell?.accessories = [
            .disclosureIndicator()
        ]
        
        let video = self.videoList[indexPath.row]
        
        cell?.provide(video)
        
        return cell
    }
    
    private func collectionViewListLayout() -> UICollectionViewLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfiguration.backgroundColor = .clear
        
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func applySnapshot() {
        let videoIDList = videoList.map { $0.id }
        
        var snapshot = Snapshot()
        snapshot.appendSections([.videos])
        snapshot.appendItems(videoIDList)
        dataSource?.apply(snapshot)
    }
    
    @objc func presentRecordingScene() {
        let viewModel = RecordingViewModel(recordManager: RecordManager())
        let recordingViewController = RecordingVideoViewController(recordingViewModel: viewModel)
        recordingViewController.modalPresentationStyle = .fullScreen
        
        self.present(recordingViewController, animated: true)
    }
}

