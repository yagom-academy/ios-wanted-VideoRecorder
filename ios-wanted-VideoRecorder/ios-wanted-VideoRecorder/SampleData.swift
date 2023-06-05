//
//  SampleData.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import Foundation
import AVKit

struct Sample {
    let video = AVPlayer(url: Bundle.main.url(forResource: "countdown", withExtension: "mp4")!)
}
