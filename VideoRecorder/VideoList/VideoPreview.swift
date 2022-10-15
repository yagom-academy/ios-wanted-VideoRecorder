//
//  VideoPreview.swift
//  VideoRecorder
//
//  Created by Subin Kim on 2022/10/15.
//

import Foundation
import AVKit

class VideoPreview {

    public var videoPlayer:AVQueuePlayer?
    public var videoPlayerLayer:AVPlayerLayer?
    var playerLooper: AVPlayerLooper?

    func playVideo(fileName:String, inView:UIView){

        let path = URL(fileURLWithPath: (NSTemporaryDirectory() as NSString).appendingPathComponent((fileName as NSString).appendingPathExtension("mp4")!))
        let asset = AVAsset(url: path)
        let playerItem = AVPlayerItem(asset: asset)

        videoPlayer = AVQueuePlayer(playerItem: playerItem)
        playerLooper = AVPlayerLooper(player: videoPlayer!,
                                      templateItem: playerItem,
                                      timeRange: CMTimeRange(start: CMTimeMake(value: 0, timescale: 1),
                                                             duration: CMTimeMake(value: 5, timescale: 1)))
//        playerLooper = AVPlayerLooper(player: videoPlayer!, templateItem: playerItem)

        videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        videoPlayerLayer!.frame = inView.bounds
        videoPlayerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill

        inView.layer.addSublayer(videoPlayerLayer!)

        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayer?.currentItem, queue: nil) { [weak self] (noty) in
           self?.videoPlayer?.seek(to: CMTime.zero)
           self?.videoPlayer?.play() }
        videoPlayer?.play()
    }

    func remove() {
        playerLooper?.disableLooping()
        videoPlayerLayer?.removeFromSuperlayer()
    }
}
