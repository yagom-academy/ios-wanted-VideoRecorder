//
//  VideoListViewController.swift
//  VideoRecorder
//
//  Created by Hyejeong Jeong on 2023/06/05.
//

import UIKit

final class VideoListViewController: UIViewController {
    private let videoListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(VideoListCell.self, forCellReuseIdentifier: VideoListCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let videos: [Video] = [
        Video(thumbnailImageName: "sample", fileName: "file1.mp4", registrationDate: Date()),
        Video(thumbnailImageName: "sample", fileName: "file2.mp4", registrationDate: Date()),
        Video(thumbnailImageName: "sample", fileName: "file3.mp4", registrationDate: Date()),
        Video(thumbnailImageName: "sample", fileName: "file4.mp4", registrationDate: Date()),
        Video(thumbnailImageName: "sample", fileName: "file5.mp4", registrationDate: Date()),
        Video(thumbnailImageName: "sample", fileName: "file6.mp4", registrationDate: Date()),
        Video(thumbnailImageName: "sample", fileName: "file7.mp4", registrationDate: Date()),
        Video(thumbnailImageName: "sample", fileName: "file8.mp4", registrationDate: Date()),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIOption()
        configureVideoListTableView()
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
    
    private func configureVideoListTableView() {
        view.addSubview(videoListTableView)
        
        videoListTableView.dataSource = self
        
        NSLayoutConstraint.activate([
            videoListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            videoListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            videoListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            videoListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension VideoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoListCell.identifier) as? VideoListCell else {
            return UITableViewCell()
        }
        
        let contents = videos[indexPath.row]
        cell.configure(thumbnailImageName: contents.thumbnailImageName, fileName: contents.fileName, date: "\(contents.registrationDate)")
        return cell
    }
}
