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
        setupNavigationItems()
        setupCollectionView()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        collectionView.collectionViewLayout = createVideoListViewLayout()
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
            collectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -8)
        ])
    }
    
    private func createVideoListViewLayout() -> UICollectionViewCompositionalLayout {
        let imageItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.25),
            heightDimension: .fractionalHeight(1.0)
        )
        let imageItem = NSCollectionLayoutItem(layoutSize: imageItemSize)
        
        let descriptionItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.70),
            heightDimension: .fractionalHeight(1.0)
        )
        let descriptionItem = NSCollectionLayoutItem(layoutSize: descriptionItemSize)
        
        var groupSize: NSCollectionLayoutSize
        
        if view.frame.height > view.frame.width {
            groupSize = NSCollectionLayoutSize(
               widthDimension: .fractionalWidth(1.0),
               heightDimension: .fractionalHeight(1.0 / 8.0)
           )
        } else {
            groupSize = NSCollectionLayoutSize(
               widthDimension: .fractionalWidth(1.0),
               heightDimension: .fractionalHeight(1.0 / 4.0)
           )
        }
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [imageItem, descriptionItem]
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
                
                cell.configure(data: video.data)
                
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
        
    private func bindSnapshot() {
        viewModel.videoPublisher()
            .sink { [weak self] videoList in
                var imageSnapshot = NSDiffableDataSourceSnapshot<Section, Video>()
                
                imageSnapshot.appendSections([.videoList])
                
                for video in videoList {
                    imageSnapshot.appendItems([video])
                    imageSnapshot.appendItems([video.copyWithoutImage()])
                }
                
                self?.dataSource?.apply(imageSnapshot)
            }
            .store(in: &subscriptions)
    }
}
