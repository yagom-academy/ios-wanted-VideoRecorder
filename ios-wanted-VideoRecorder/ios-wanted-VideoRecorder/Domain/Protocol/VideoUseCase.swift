//
//  VideoUseCase.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/09.
//

import AVKit

protocol VideoUseCase {
    
    var videoPlayer: AVPlayer { get set }
    
    func playVideo()
    
    func pauseVideo()
    
    func checkPlayingVideo() -> Bool
    
    func goBackVideo(by second: Int64)
    
    func changedVideoTime(timeRatio: Double)
    
    func replayFromBeginning()
}
