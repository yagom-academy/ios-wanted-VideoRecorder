//
//  ViewController.swift
//  VideoRecorder
//
//  Created by kjs on 2022/10/07.
//

import UIKit

class VideoListViewController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return false
    }

    @IBOutlet weak var tableView: UITableView!

    var videoFiles = [
        VideoModel(fileName: "Nature.mp4", playTime: "3:21", date: "2022-09-22"),
        VideoModel(fileName: "Food.mp4", playTime: "15:50", date: "2022-09-17"),
        VideoModel(fileName: "Building.mp4", playTime: "0:21", date: "2022-09-04"),
        VideoModel(fileName: "Concert.mp4", playTime: "1:13:27", date: "2022-08-05"),
        VideoModel(fileName: "Bridge.mp4", playTime: "32:03", date: "2022-07-21"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "VideoListCell", bundle: nil), forCellReuseIdentifier: VideoListCell.identifier)

    }


    @IBAction func recordButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.isNavigationBarHidden = true
        performSegue(withIdentifier: "record", sender: nil)
    }
}

extension VideoListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoFiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoListCell.identifier, for: indexPath) as? VideoListCell else {
            return UITableViewCell()
        }

        cell.titleLabel.text = videoFiles[indexPath.row].fileName
        cell.dateLabel.text = videoFiles[indexPath.row].date
        cell.timeLabel.text = videoFiles[indexPath.row].playTime

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            videoFiles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
