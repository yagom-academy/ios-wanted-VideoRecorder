//
//  VideoListView.swift
//  VideoRecorder
//
//  Created by KangMingyo on 2022/10/11.
//

import UIKit

class VideoListView: UIView {
    
    var start: Int = 0
    var isLoadOver = false
    var isLoading = false
    var videoMetaDatas = [VideoMetaData]()
    weak var delegate: VideoListViewDelegate?
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        f.locale = Locale(identifier: "ko_kr")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    
    let videoListTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadData(true)
        
        setupTableView()
        
        addView()
        configure()
    }
    
    required init?(coder NSCoder : NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData(_ refresh: Bool) {
        if refresh {
            self.videoMetaDatas = []
            self.start = 0
            self.isLoadOver = false
        }
        if isLoadOver || isLoading { return }
        isLoading = true
        
        VideoManager.shared.loadVideos(start: self.start) { result in
            switch result {
            case .success(let metaDatas):
                self.videoMetaDatas.append(contentsOf: metaDatas)
                self.videoListTableView.reloadData()
                self.start += metaDatas.count
                if metaDatas.count != 6 {
                    self.isLoadOver = true
                }
                break
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
            self.isLoading = false
        }
    }
    
    func timeString(from timeInterval: TimeInterval) -> String {
        let seconds = Int(timeInterval.truncatingRemainder(dividingBy: 60))
        let minutes = Int(timeInterval.truncatingRemainder(dividingBy: 60 * 60) / 60)
        return String(format: "%.2d:%.2d", minutes, seconds)
    }
    
    func setupTableView() {
        videoListTableView.delegate = self
        videoListTableView.dataSource = self
        videoListTableView.register(VideoListTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func addView() {
        addSubview(videoListTableView)
    }
    
    func configure() {
        NSLayoutConstraint.activate([
            videoListTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            videoListTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            videoListTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            videoListTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension VideoListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoMetaDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VideoListTableViewCell
        let data = videoMetaDatas[indexPath.row]
        cell.thumbnailImageView.image = UIImage(data: data.thumbnail!)
        cell.timelabel.text = timeString(from: data.videoLength)
        cell.videoNameLabel.text = data.name
        cell.dateLabel.text = formatter.string(from: data.createdAt!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == videoMetaDatas.count-1 {
            self.loadData(false)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            VideoManager.shared.deleteVideo(data: videoMetaDatas[indexPath.row]) { result in
                switch result {
                case .success:
                    self.videoMetaDatas.remove(at: indexPath.row)
                    break
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
                self.videoListTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.showDetail(videoMetaDatas[indexPath.row])
    }
}

protocol VideoListViewDelegate: AnyObject {
    func showDetail(_ metaData: VideoMetaData)
}
