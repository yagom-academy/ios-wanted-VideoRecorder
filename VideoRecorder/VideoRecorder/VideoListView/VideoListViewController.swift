//
//  ViewController.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/05.
//

import UIKit
import Photos

final class VideoListViewController: UIViewController {
    private let tableView: UITableView = UITableView()
    
    private let imageManager: PHCachingImageManager = PHCachingImageManager()
    
    private let viewModel: VideoListViewModel
    
    init(viewModel: VideoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRootView()
        configureNavigationBar()
        configureTableView()
        setupLayoutConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let imageSize = CGSize(width: 80, height: 60)
        startImageCaching(imageSize: imageSize)
        tableView.reloadData()
    }
    
    private func startImageCaching(imageSize: CGSize) {
        viewModel.fetchedAssets { [weak self] videoAssets in
            self?.imageManager.startCachingImages(
                for: videoAssets,
                targetSize: imageSize,
                contentMode: .aspectFit,
                options: nil
            )
        }
    }

    private func configureRootView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        let listImage = UIImage(systemName: "list.triangle")
        let titleText = "Video List"
        let listImageView = UIImageView(image: listImage)
        listImageView.tintColor = .black
        let titleLabel = {
            let label = UILabel()
            label.text = titleText
            label.font = .systemFont(ofSize: 24, weight: .heavy)
            label.textColor = .black
            
            return label
        }()
        let stackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.spacing = 8
            
            return stackView
        }()
        
        stackView.addArrangedSubview(listImageView)
        stackView.addArrangedSubview(titleLabel)
        
        let leftBarButtonItem = UIBarButtonItem(customView: stackView)
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "video.fill.badge.plus"),
            style: .plain,
            target: self,
            action: #selector(presentRecordingView)
        )
        rightBarButtonItem.tintColor = .systemIndigo
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .white
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationController?.navigationBar.standardAppearance = barAppearance
    }
    
    @objc
    private func presentRecordingView() {
        let indexPath = IndexPath(row: viewModel.fetchedAssets.count - 1, section: 0)
        let lastCell = tableView.cellForRow(at: indexPath) as? VideoListCell
        
        let videoRecordingService = VideoRecordingService(albumRepository: viewModel.albumRepository,
                                                          deviceOrientation: .portrait)
        let recordingViewModel = RecordingViewModel(videoRecordingService: videoRecordingService)
        let recordingViewController = RecordingViewController(
            viewModel: recordingViewModel,
            thumbnailImage: lastCell?.thumbnailView.image
        )
        recordingViewController.modalPresentationStyle = .fullScreen
        
        self.present(recordingViewController, animated: true)
    }
    
    private func configureTableView() {
        tableView.register(VideoListCell.self, forCellReuseIdentifier: VideoListCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    private func requestImage(
        at index: Int,
        size: CGSize,
        resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void
    ) {
        guard let videoAsset = viewModel.fetchedAssets[safe: index] else {
            return
        }
        
        imageManager.requestImage(for: videoAsset,
                                  targetSize: size,
                                  contentMode: .aspectFit,
                                  options: nil,
                                  resultHandler: resultHandler)
    }
}

extension VideoListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.videoDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: VideoListCell.identifier,
            for: indexPath
        ) as? VideoListCell else {
            return UITableViewCell()
        }
        
        guard let videoData = viewModel.videoDataList[safe: indexPath.row] else {
            return cell
        }
        
        cell.titleLabel.text = videoData.name
        cell.dateLabel.text = videoData.creationDate
        cell.accessoryView = VideoListCellAccessoryView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        
        let imageSize = CGSize(width: 40, height: 20)
        
        requestImage(at: indexPath.row, size: imageSize) { [weak cell] image, _ in
            guard let cell else { return }
            cell.thumbnailView.image = image
        }
        
        return cell
    }
}

extension VideoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let videoData = viewModel.videoDataList[safe: indexPath.row],
              let fileURL = videoData.name else {
            return
        }
        
        let videoPlayerViewModel = VideoPlayerViewModel(fileURLString: fileURL)
        let videoPlayerViewController = VideoPlayerViewController(viewModel: videoPlayerViewModel)
        
        self.navigationController?.pushViewController(videoPlayerViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completion in
            self?.viewModel.deleteVideo(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
