//
//  VideoPlayViewController.swift
//  VideoRecorder
//
//  Created by 김지인 on 2022/10/11.
//

import UIKit


final class VideoPlayViewController: UIViewController {

    @IBOutlet private weak var videoView: VideoView!
    private var backViewTapFlag: Bool = false
    var url: URL? {
            didSet {
                guard let url = url else { return }
            }
        }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoView.url = url
        tapVideoView()
    }
    
    private func tapVideoView() {
        self.videoView.layoutIfNeeded()
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedBackView(_:)))
        self.videoView.addGestureRecognizer(gesture)
    }
    
    // TODO: 애니메이션 적용이 안됨.
    @objc func tappedBackView(_ gesture: UITapGestureRecognizer) {
        backViewTapFlag.toggle()
        UIView.animate(withDuration: 0.5) {
            self.videoView.playView.isHidden = self.backViewTapFlag
        }
    }
    
}
