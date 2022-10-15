//
//  Model.swift
//  VideoRecorder
//
//  Created by so on 2022/10/11.
//

import AVFoundation
import UIKit

struct VideoModel {
    var time: CMTime
    var fileURL: URL
    
    init(time: CMTime, fileURL: URL) {
        self.time = time
        self.fileURL = fileURL
    }
}
