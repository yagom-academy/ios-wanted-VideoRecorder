//
//  VideoListViewController.swift
//  VideoRecorder
//
//  Created by kjs on 2022/10/07.
//

import UIKit
import UniformTypeIdentifiers
import CoreData

final class VideoListViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(VideoListCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var isLoading = false
    var hasNextPage = true
    let fireStore = FireStoreManager()
    var videoList: [VideoModel] = []
    var offset = 0

    private let navigationLeftBarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "list.triangle"), for: .normal)
        button.tintColor = Color.label
        button.setTitle("Video List", for: .normal)
        button.titleLabel?.font = Font.title3
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setTitleColor(Color.label, for: .normal)
        button.marginImageWithText(margin: 15)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.systemBackground
        setTableView()
        configureNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    private func setTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationLeftBarButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "video.fill.badge.plus"), style: .plain, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem?.tintColor = Color.purple
    }
    
    @objc
    private func addTapped() {
        VideoHelper.startRecording(delegate: self)
    }

    private func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.color = UIColor.darkGray
            spinner.hidesWhenStopped = true
            spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 60)
            tableView.tableFooterView = spinner
            spinner.startAnimating()
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                self.fetchData()
            }
        }
    }

    private func fetchData() {
        let request: NSFetchRequest<VideoModel> = VideoModel.fetchRequest()
        request.fetchLimit = 8
        request.fetchOffset = offset
        
        do {
            let nextVideoList = try CoreDataService.shared.context.fetch(request)
            if nextVideoList.isEmpty {
                DispatchQueue.main.async {
                    self.tableView.tableFooterView = nil
                    self.isLoading = false
                    self.tableView.reloadData()
                }
            } else {
                videoList += nextVideoList
                offset += nextVideoList.count
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.tableView.tableFooterView = nil
                    self.tableView.reloadData()
                }
            }
        } catch {
            print("<<Error fetching data from context>>")
            print(error)
        }
    }
}

extension VideoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? VideoListCell else { return UITableViewCell() }
        let video = videoList[indexPath.row]
        let image = VideoHelper.generateThumbnail(from: FileService.shared.loadVideoURL(data: video))
        
        cell.thumbnailImageView.image = image
        cell.videoNameLabel.text = video.name
        cell.runningTimeLabel.text = video.runningTime
        cell.dateLabel.text = video.date
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            CoreDataService.shared.context.delete(self.videoList[indexPath.row])
            FileService.shared.deleteFile(FileService.shared.loadVideoURL(data: self.videoList[indexPath.row]))
            self.fireStore.delete(self.videoList[indexPath.row])
            self.videoList.remove(at: indexPath.row)
            CoreDataService.shared.saveContext()
            self.offset -= 1
            tableView.reloadData()
            success(true)
        }
        delete.backgroundColor = .systemRed
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions:[delete])
        swipeActionConfiguration.performsFirstActionWithFullSwipe = false
        return swipeActionConfiguration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        playVideo(indexPath)
    }
    
    func playVideo(_ indexPath: IndexPath) {
        let selectedVideo = videoList[indexPath.row]
        let playVideoViewController = PlayVideoViewController()
        playVideoViewController.navigationLeftBarButton.setTitle(selectedVideo.name, for: .normal)
        playVideoViewController.videoUrl = FileService.shared.loadVideoURL(data: selectedVideo)
        self.navigationController?.pushViewController(playVideoViewController, animated: true)
    }
}

extension VideoListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? NSString,
            mediaType.isEqual(to: UTType.movie.identifier),
            let movURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        else { return }

        let alert = UIAlertController(title: "비디오 제목을 입력하세요", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true)
            var title = String()
            if let isTextField = alert.textFields, let firstTextField = isTextField.first {
                title = firstTextField.text ?? "제목없음"
            }
            let (date, time): (String, String) = VideoHelper.searchingVideoData(from: movURL)
            let video = Video(name: title, runningTime: time, date: date, videoPath: movURL.relativeString)
            let videoModel = VideoModel(context: CoreDataService.shared.context)
            videoModel.identifier = video.identifier
            videoModel.videoPath = movURL.relativeString
            videoModel.name = video.name
            videoModel.date = video.date
            videoModel.runningTime = video.runningTime
            CoreDataService.shared.saveContext()
            
            DispatchQueue.global(qos: .background).async {
                self.fireStore.save(video)
                try? FileService.shared.saveVideo(data: video)
            }
        }))
        
        picker.present(alert, animated: true)
    }

    @objc
    private func video(_ videoPath: String,
                       didFinishSavingWithError error: Error?,
                       contextInfo info: AnyObject) {
        if let error = error {
            let alert = UIAlertController(title: "Error", message: "저장에 실패했습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.dismiss(animated: true)
            }))
            print(error.localizedDescription)
            present(alert, animated: true)
        }
    }
}

extension VideoListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y

        if position > tableView.contentSize.height - scrollView.frame.size.height + 100 {
            if !isLoading {
                loadMoreData()
            }
        }
    }
}
