//
//  videoListCell.swift
//  VideoRecorder
//
//  Created by Subin Kim on 2022/10/11.
//

import UIKit

class VideoListCell: UITableViewCell {
    static let identifier = "videoListCell"
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var preview: UIView!
    let longTouchGesture = UILongPressGestureRecognizer(target: VideoListCell.self, action: #selector(longPressed))

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.addGestureRecognizer(longTouchGesture)
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressed)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func longPressed(_ sender: UILongPressGestureRecognizer) {
        print("loooooooooong")
        print(sender.state.rawValue)
        let myVideoPlayerLooped = VideoPreview()

        switch sender.state {
        case .began:
            preview.isHidden = false
            myVideoPlayerLooped.playVideo(fileName: titleLabel.text!, inView: preview)

        case .ended:
            myVideoPlayerLooped.remove()
            preview.isHidden = true
        default:
            return
        }
    }
}
