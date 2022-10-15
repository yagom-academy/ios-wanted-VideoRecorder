//
//  LodingTableViewCell.swift
//  VideoRecorder
//
//  Created by so on 2022/10/13.
//

import UIKit

class LodingTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func start() {
        activityIndicatorView.startAnimating()
     
    }
}
