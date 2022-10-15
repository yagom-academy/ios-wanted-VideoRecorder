//
//  MediaView.swift
//  VideoRecorder
//
//  Created by 신병기 on 2022/10/14.
//

import UIKit
import AVFoundation

class MediaView: UIView {
    override static var layerClass: AnyClass { AVPlayerLayer.self }
    
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }
    
    private var playerLayer: AVPlayerLayer {
        let layer = layer as! AVPlayerLayer
        layer.videoGravity = .resizeAspectFill
        return layer
    }
}
