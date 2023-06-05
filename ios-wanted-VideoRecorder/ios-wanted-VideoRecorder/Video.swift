//
//  Video.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import AVKit

struct Video: Identifiable {
    let id = UUID()
    var title: String
    var date: Date
    var video: AVPlayer?
}
