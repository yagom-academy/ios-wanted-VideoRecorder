//
//  SampleData.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import AVKit

struct Sample {
    var videos: [Video] = [
        Video(title: "Countdown.mp4", date: Date(), videoURL: Bundle.main.url(forResource: "countdown", withExtension: "mp4"), videoLength: "12:03"),
        Video(title: "Forest.mp4", date: Date(), videoURL: Bundle.main.url(forResource: "forest", withExtension: "mp4"), videoLength: "32:10"),
        Video(title: "river.mp4", date: Date(), videoURL: Bundle.main.url(forResource: "river", withExtension: "mp4"), videoLength: "00:05")
    ]
}
