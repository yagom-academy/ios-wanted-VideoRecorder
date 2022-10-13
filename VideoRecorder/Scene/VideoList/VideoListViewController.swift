//
//  VideoListViewController.swift
//  VideoRecorder
//
//  Created by kjs on 2022/10/07.
//

import UIKit
import UniformTypeIdentifiers

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
    
    var cellVideoList: [Video] = []
    var videoList: [Video] = [
        Video(name: "Naure", thumbnail: UIImage(named: "sample")!, runningTime: "3:21", date: "2022-09-22"),
        Video(name: "Food", thumbnail: UIImage(named: "sample")!, runningTime: "1:03:21", date: "2022-09-22"),
        Video(name: "Buliding", thumbnail: UIImage(named: "sample")!, runningTime: "57:21", date: "2022-09-22"),
        Video(name: "Concert", thumbnail: UIImage(named: "sample")!, runningTime: "3:21", date: "2022-09-22"),
        Video(name: "Bridge", thumbnail: UIImage(named: "sample")!, runningTime: "32:21", date: "2022-09-22"),
        Video(name: "Naure", thumbnail: UIImage(named: "sample")!, runningTime: "3:21", date: "2022-09-22"),
        Video(name: "Food", thumbnail: UIImage(named: "sample")!, runningTime: "1:03:21", date: "2022-09-22"),
        Video(name: "Buliding", thumbnail: UIImage(named: "sample")!, runningTime: "57:21", date: "2022-09-22"),
        Video(name: "Concert", thumbnail: UIImage(named: "sample")!, runningTime: "3:21", date: "2022-09-22"),
        Video(name: "Bridge", thumbnail: UIImage(named: "sample")!, runningTime: "32:21", date: "2022-09-22"),
        Video(name: "Naure", thumbnail: UIImage(named: "sample")!, runningTime: "3:21", date: "2022-09-22"),
        Video(name: "Food", thumbnail: UIImage(named: "sample")!, runningTime: "1:03:21", date: "2022-09-22"),
        Video(name: "Buliding", thumbnail: UIImage(named: "sample")!, runningTime: "57:21", date: "2022-09-22"),
        Video(name: "Concert", thumbnail: UIImage(named: "sample")!, runningTime: "3:21", date: "2022-09-22"),
        Video(name: "Bridge", thumbnail: UIImage(named: "sample")!, runningTime: "32:21", date: "2022-09-22"),
    ]

    private let navigationLeftBarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "list.triangle"), for: .normal)
        button.tintColor = Color.label
        
        button.setTitle("  Video List", for: .normal)
        button.titleLabel?.font = Font.title3
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setTitleColor(Color.label, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.systemBackground
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        configureNavigation()
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
    func loadMoreData() {
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

    func fetchData() {
        let index = cellVideoList.count
        var newVideoList: [Video] = []
        
        for i in index..<(index + 6) {
            if i >= videoList.count {
                break
            }
            let data = videoList[i]
            newVideoList.append(data)
        }
        
        DispatchQueue.main.async {
            self.tableView.tableFooterView = nil
            self.isLoading = false
            self.cellVideoList.append(contentsOf: newVideoList)
            self.hasNextPage = self.cellVideoList.count >= self.videoList.count ? false : true
            self.tableView.reloadData()
        }
        
    }
    
}

extension VideoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellVideoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? VideoListCell else { return UITableViewCell() }
        
        cell.videoNameLabel.text = videoList[indexPath.row].name
        cell.thumbnailImageView.image = UIImage(named: "sample")
        cell.runningTimeLabel.text = videoList[indexPath.row].runningTime
        cell.dateLabel.text = videoList[indexPath.row].date
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.videoList.remove(at: indexPath.row)
            tableView.reloadData()
            success(true)
        }
        delete.backgroundColor = .systemRed
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions:[delete])
        swipeActionConfiguration.performsFirstActionWithFullSwipe = false
        return swipeActionConfiguration
    }
}

extension VideoListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? NSString,
            mediaType.isEqual(to: UTType.movie.identifier),
            let movURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(movURL.relativePath)
        else { return }

        UISaveVideoAtPathToSavedPhotosAlbum(movURL.relativePath, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)

        let alert = UIAlertController(title: "비디오 제목을 입력하세요", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // TODO: - use textField.text
            self.dismiss(animated: true)
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

        if position > tableView.contentSize.height - 100 - scrollView.frame.size.height {
            if !isLoading && hasNextPage {
                loadMoreData()
            }
        }
    }
}
