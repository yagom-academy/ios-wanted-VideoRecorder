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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
