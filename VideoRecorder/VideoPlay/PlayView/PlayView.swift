//
//  PlayView.swift
//  VideoRecorder
//
//  Created by 김지인 on 2022/10/11.
//

import UIKit

final class PlayView: UIView {
    
    @IBOutlet private weak var VideoProgressView: UIProgressView!
    @IBOutlet private weak var nowPlayTimeLabel: UILabel!
    @IBOutlet private weak var totalPlayTimeLabel: UILabel!
    @IBOutlet private weak var backwordButton: UIButton!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
}
