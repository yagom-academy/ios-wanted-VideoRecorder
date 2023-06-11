//
//  VideoListViewController.swift
//  VideoRecorder
//
//  Created by Hyejeong Jeong on 2023/06/05.
//

import UIKit

final class VideoListViewController: UIViewController {
    enum Section {
        case main
    }
    
    private var videoInfoList: [VideoInfo]?
    private var dataSource: UITableViewDiffableDataSource<Section, VideoInfo>?
    
    private let videoListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(VideoListCell.self, forCellReuseIdentifier: VideoListCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let videos: [VideoInfo] = [
        VideoInfo(id: UUID(), videoURL: URL(string: "www.naver.com")!, thumbnailImage: (UIImage(named: "sample")?.pngData())!, duration: 0.3, fileName: "file1.mp4", registrationDate: Date())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIOption()
        configureVideoListTableView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchVideoInfo()
        applySnapshot()
    }
    
    private func configureUIOption() {
        let rightBarButtonIcon = UIImage(systemName: SystemImageName.addedVideo)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.systemIndigo)
        
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: VideoListTitleView())
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarButtonIcon,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(pushAddVideoViewController))
    }
    
    @objc private func pushAddVideoViewController() {
        let addVideoViewController = AddVideoViewController()
        
        navigationController?.pushViewController(addVideoViewController, animated: true)
    }
    
    private func fetchVideoInfo() {
        videoInfoList = CoreDataManager.shared.fetch()
    }
    
    private func configureVideoListTableView() {
        view.addSubview(videoListTableView)
        
        videoListTableView.dataSource = dataSource
        videoListTableView.delegate = self
        
        NSLayoutConstraint.activate([
            videoListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            videoListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            videoListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            videoListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, VideoInfo>(tableView: videoListTableView) {
            [weak self] (tableView, indexPath, video) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoListCell.identifier) as? VideoListCell else {
                return UITableViewCell()
            }

            let contents = self?.videoInfoList?[indexPath.row]
            
            cell.configure(playbackTime: contents?.duration ?? 0.5,
                           fileName: contents?.fileName ?? "",
                           date: contents?.registrationDate.translateLocalizedFormat() ?? "")
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, VideoInfo>()
        
        guard let videoInfoList else { return }
        
        snapshot.appendSections([.main])
        snapshot.appendItems(videoInfoList, toSection: .main)
        dataSource?.apply(snapshot)
    }
}

// MARK: - Table view delegate

extension VideoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let videoInfo = videoInfoList?[indexPath.row] else { return nil }
        
        let removeAction = UIContextualAction(style: .destructive, title: "Remove") { [weak self] _, _, _ in
            self?.videoInfoList?.remove(at: indexPath.row)
            self?.removeVideo(id: videoInfo.id, url: videoInfo.videoURL)
            self?.applySnapshot()
        }
        
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
    
    private func removeVideo(id: UUID, url: URL) {
        let fileManager = FileManager.default
        let filePath = url.path
        
        print(filePath)
        
        if fileManager.fileExists(atPath: filePath) {
            do {
                try fileManager.removeItem(atPath: filePath)
                CoreDataManager.shared.delete(id: id)
            } catch {
                print("remove failed: \(error)")
            }
        } else {
            print("File not found at path: \(filePath)")
        }
    }
}
