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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createVideoListViewLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(VideoImageCell.self,
                                forCellWithReuseIdentifier: VideoImageCell.reuseIdentifier)
        collectionView.register(VideoDescriptionCell.self,
                                forCellWithReuseIdentifier: VideoDescriptionCell.reuseIdentifier)
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupCollectionView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupCollectionView() {
        addSubviews()
        setupCollectionViewConstraints()
        setupDataSource()
        bind()
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    private func setupCollectionViewConstraints() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -8)
        ])
    }
    
    private func createVideoListViewLayout() -> UICollectionViewCompositionalLayout {
        let videoItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.20),
            heightDimension: .fractionalWidth(1.0 / 6.0)
        )
        let videoitem = NSCollectionLayoutItem(layoutSize: videoItemSize)
        
        let descriptionItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.80),
            heightDimension: .fractionalWidth(1.0 / 6.0)
        )
        let descriptionItem = NSCollectionLayoutItem(layoutSize: descriptionItemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [videoitem, descriptionItem]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Video>(collectionView: collectionView) { collectionView, indexPath, video in
            if indexPath.item % 2 == 0 {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: VideoImageCell.reuseIdentifier,
                    for: indexPath) as? VideoImageCell else {
                    return UICollectionViewCell()
                }
                
                cell.configure(image: video.image)
                
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: VideoDescriptionCell.reuseIdentifier,
                    for: indexPath) as? VideoDescriptionCell else {
                    return UICollectionViewCell()
                }
                
                cell.configure(title: video.title, date: video.date)
                
                return cell
            }
        }
    }
        
    private func bind() {
        viewModel.videoPublisher()
            .sink { [weak self] videoList in
                var imageSnapshot = NSDiffableDataSourceSnapshot<Section, Video>()
                
                imageSnapshot.appendSections([.videoList])
                
                for video in videoList {
                    imageSnapshot.appendItems([video])
                    imageSnapshot.appendItems([video.copy()])
                }
                
                self?.dataSource?.apply(imageSnapshot)
            }
            .store(in: &subscriptions)
    }
}
