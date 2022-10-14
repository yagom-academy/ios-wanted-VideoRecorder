//
//  ViewController.swift
//  VideoRecorder
//
//  Created by kjs on 2022/10/07.
//

import UIKit
import AVFoundation

class VideoListViewController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return false
    }

    @IBOutlet weak var tableView: UITableView!

    private var videoList = [VideoData]()
    private var offset = 0
    private var isLoading = false
//    private let spinner = UIActivityIndicatorView(style: .large)
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = UIColor.darkGray
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 60)

        return spinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "VideoListCell", bundle: nil), forCellReuseIdentifier: VideoListCell.identifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 가장 최근에 찍은 영상이 상단에 있어야하니까 초기화하고 다시 fetch
        videoList.removeAll()
        offset = 0
        videoList = CoreDataManager.shared.fetchData(offset)
        offset += videoList.count
        tableView.reloadData()
    }

    @IBAction func recordButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.isNavigationBarHidden = true
        performSegue(withIdentifier: "record", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextVC = segue.destination as? VideoRecordViewController else { return }

        if videoList.isEmpty { return }
        nextVC.thumbnailImage = ThumbnailCache.shared.object(forKey: videoList.first!.name as NSString) ?? UIImage(systemName: "photo")!
    }
}

extension VideoListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoListCell.identifier, for: indexPath) as? VideoListCell else {
            return UITableViewCell()
        }

        let i = indexPath.row

        cell.titleLabel.text = videoList[i].name
        cell.dateLabel.text = videoList[i].date
        cell.timeLabel.text = videoList[i].playTime
        cell.thumbnail.image = getThumbnail(videoList[i].name) ?? UIImage(systemName: "photo")

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataManager.shared.deleteData(videoList[indexPath.row])
            videoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            FirebaseStorageManager.shared.removeVideo(videoName: videoList[indexPath.row].name)
            offset -= 1
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayViewController") as? VideoPlayViewController else {return}

        let url = URL(fileURLWithPath: (NSTemporaryDirectory() as NSString).appendingPathComponent((videoList[indexPath.row].name as NSString).appendingPathExtension("mp4")!))
        nextVC.url = url
        nextVC.naviTitle = videoList[indexPath.row].name
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isReachingEnd = scrollView.contentOffset.y >= 0
        && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)

        if isReachingEnd && !isLoading {
            self.isLoading = true
            self.tableView.tableFooterView = self.spinner
            self.spinner.startAnimating()

            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: {
                let fetchedList = CoreDataManager.shared.fetchData(self.offset)
                if fetchedList.isEmpty {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.tableView.tableFooterView = nil
                    }
                } else {
                    self.videoList += fetchedList
                    self.offset += fetchedList.count
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.tableView.tableFooterView = nil
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }

}

extension VideoListViewController {
    func getThumbnail(_ fileName: String) -> UIImage? {

        if let cachedImage = ThumbnailCache.shared.object(forKey: fileName as NSString) {
            return cachedImage
        } else {
            let path = URL(fileURLWithPath: (NSTemporaryDirectory() as NSString).appendingPathComponent((fileName as NSString).appendingPathExtension("mp4")!))
            do {
                let asset = AVURLAsset(url: path, options: nil)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                imageGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                ThumbnailCache.shared.setObject(thumbnail, forKey: fileName as NSString)

                return thumbnail
            } catch {
                print("Error generating thumbnail")
                return nil
            }

        }
    }

    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.color = UIColor.darkGray
            spinner.hidesWhenStopped = true
            spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 60)
            self.tableView.tableFooterView = spinner
            spinner.startAnimating()
//            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
//                self.fetchData()
//            }
            let fetchedList = CoreDataManager.shared.fetchData(offset)
            if fetchedList.isEmpty {
                self.isLoading = false
                self.tableView.tableFooterView = nil
                return
            }

            videoList += fetchedList
            offset += fetchedList.count
            self.isLoading = false
            self.tableView.tableFooterView = nil
            tableView.reloadData()
        }
    }
}
