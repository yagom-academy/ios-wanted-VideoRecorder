//
//  SampleData.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import Foundation
import AVKit

struct Sample {
    
    var videos: [Video] = [
        Video(title: "Countdown.mp4", date: Date(), video: AVPlayer(url: Bundle.main.url(forResource: "countdown", withExtension: "mp4")!)),
        Video(title: "Forest.mp4", date: Date(), video: AVPlayer(url: Bundle.main.url(forResource: "forest", withExtension: "mp4")!)),
        Video(title: "river.mp4", date: Date(), video: AVPlayer(url: Bundle.main.url(forResource: "river", withExtension: "mp4")!))
    ]
}
