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
        case loading
    }
    
    private var videoListDataSource: UICollectionViewDiffableDataSource<Section, Video>?
    private var loadingDataSource: UICollectionViewDiffableDataSource<Section, Bool>?
    private let viewModel = VideoListViewModel()
    private let thumbnailManager = ThumbnailManager()
    private var subscriptions = Set<AnyCancellable>()
    private var loadingView = LoadingView()
    private var isPaging = false {
        didSet {
            configureLoadingStatus()
        }
    }
    private var isLastData = false
    
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
        bind()
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(loadingView)
    }
    
    private func layout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -8),
            
            loadingView.centerXAnchor.constraint(equalTo: safe.centerXAnchor, constant: -8),
            loadingView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -8),
            loadingView.widthAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 0.4),
            loadingView.heightAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 0.4)
        ])
    }
    
    private func configureLoadingStatus() {
        if self.isPaging {
            self.loadingView.start()
        } else {
            self.loadingView.stop()
        }
    }
    
    // MARK: - Configure CollectionView
    private func createListLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout() { [weak self] _, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
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
        videoListDataSource = UICollectionViewDiffableDataSource<Section, Video>(collectionView: collectionView) { [weak self] collectionView, indexPath, video in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: VideoListCell.reuseIdentifier,
                for: indexPath) as? VideoListCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(title: video.title, date: video.date)
            
            self?.thumbnailManager.generateThumbnail(for: video.data) { image in
                guard let image else { return }
                
                DispatchQueue.main.async {
                    cell.configureThumbnail(image: image)
                }
            }
            
            if let thumbnailText = self?.thumbnailManager.getVideoPlayTime(for: video.data) {
                cell.configureThumbnail(timeText: thumbnailText)
            }
            
            return cell
        }
    }
        
    private func bind() {
        viewModel.videoPublisher()
            .receive(on: DispatchQueue.global())
            .sink { [weak self] videoList in
                self?.applyVideoListCellSnapshot(by: videoList)
                self?.isPaging = false
            }
            .store(in: &subscriptions)
        
        viewModel.isLastDataPublisher()
            .assign(to: \.isLastData, on: self)
            .store(in: &subscriptions)
    }
    
    private func applyVideoListCellSnapshot(by videoList: [Video]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Video>()

        snapshot.appendSections([.videoList])
        snapshot.appendItems(videoList)

        videoListDataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension VideoListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let video = viewModel.requestVideo(by: indexPath) else { return }
        
        let playVideoViewController = PlayVideoViewController(video: video)
        
        navigationController?.pushViewController(playVideoViewController, animated: true)
    }
}

extension VideoListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        let isScrollingBottom = offsetY > (contentHeight - height)
        
        if isScrollingBottom && !isLastData && !isPaging {
            beginPaging()
        }
    }
    
    private func beginPaging() {
        isPaging = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.viewModel.requestFetchVideo()
        }
    }
}
