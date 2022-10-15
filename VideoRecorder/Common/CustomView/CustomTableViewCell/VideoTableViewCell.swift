//
//  VideoTableViewCell.swift
//  VideoRecorder
//
//  Created by so on 2022/10/11.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var videoTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        videoImage.backgroundColor = .white
        videoImage.layer.cornerRadius = 15
        videoTime.clipsToBounds = true
        videoTime.layer.cornerRadius = 3
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

