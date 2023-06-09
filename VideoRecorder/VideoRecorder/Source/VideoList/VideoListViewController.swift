//
//  VideoListViewController.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/05.
//

import UIKit
import Combine

final class VideoListViewController: UIViewController {
    enum Section {
        case videoList
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Video>?
    private let viewModel = VideoListViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createListLayout())
        
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(VideoListCell.self,
                                forCellWithReuseIdentifier: VideoListCell.reuseIdentifier)
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationItems()
        setupCollectionView()
    }
        
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationItems() {
        setupLeftBarButton()
        setupRightBarButton()
    }
    
    private func setupLeftBarButton() {
        let systemImageName = "list.triangle"
        let title = "Video List"
        
        let listImage = UIImage(systemName: systemImageName)
        let titleImageView = UIImageView(image: listImage)
        titleImageView.tintColor = .label
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 24)
        
        let stackView = UIStackView(arrangedSubviews: [titleImageView, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fill
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: stackView)
    }
    
    private func setupRightBarButton() {
        let systemImageName = "video.fill.badge.plus"
        
        let videoImage = UIImage(systemName: systemImageName)
        
        let rightBarButton = UIBarButtonItem(image: videoImage,
                                             style: .plain,
                                             target: self,
                                             action: #selector(recordVideo))
        
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func recordVideo() {
        let videoRecordViewController = RecordVideoViewController()
        
        navigationController?.pushViewController(videoRecordViewController, animated: true)
    }
    
    private func setupCollectionView() {
        addSubviews()
        layout()
        setupDataSource()
        bindSnapshot()
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    private func layout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -8)
        ])
    }
    
    private func createListLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout() { [weak self] _, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .grouped)
            config.showsSeparators = true
            config.backgroundColor = .systemBackground
            config.headerMode = .firstItemInSection
            config.trailingSwipeActionsConfigurationProvider = self?.deleteCell
            
            let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            
            return section
        }
        
        return layout
    }
    
    private func deleteCell(_ indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteActionTitle = "Delete"
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: deleteActionTitle) { [weak self] _, _, _ in
            self?.viewModel.delete(by: indexPath)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Video>(collectionView: collectionView) { collectionView, indexPath, video in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: VideoListCell.reuseIdentifier,
                for: indexPath) as? VideoListCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(title: video.title, date: video.date)
            
            return cell
        }
    }
        
    private func bindSnapshot() {
        viewModel.videoPublisher()
            .sink { [weak self] videoList in
                var imageSnapshot = NSDiffableDataSourceSnapshot<Section, Video>()
                
                imageSnapshot.appendSections([.videoList])
                imageSnapshot.appendItems(videoList)
                
                self?.dataSource?.apply(imageSnapshot)
            }
            .store(in: &subscriptions)
    }
}

extension VideoListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let video = viewModel.requestVideo(by: indexPath) else { return }
        
        let playVideoViewController = PlayVideoViewController(video: video)
        
        navigationController?.pushViewController(playVideoViewController, animated: true)
    }
}
