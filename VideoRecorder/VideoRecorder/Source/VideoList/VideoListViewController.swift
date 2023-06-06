//
//  VideoListViewController.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/05.
//

import UIKit

final class VideoListViewController: UIViewController {
    enum Section {
        case videoList
    }
    
    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createVideoListViewLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
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
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    private func setupCollectionViewConstraints() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: 12),
            collectionView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: 12)
        ])
    }
    
    private func createVideoListViewLayout() -> UICollectionViewLayout {
        let videoItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.25),
            heightDimension: .fractionalHeight(1.0)
        )
        let videoitem = NSCollectionLayoutItem(layoutSize: videoItemSize)
        
        let descriptionItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.75),
            heightDimension: .fractionalHeight(1.0)
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
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func setupDataSource() {
        let dataSource = UICollectionViewDiffableDataSource<Section, Video>(collectionView: collectionView) { collectionView, indexPath, video in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoImageCell.reuseIdentifier,
                                                                for: indexPath) as? VideoImageCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(image: video.image)
            
            return cell
        }
    }
}
