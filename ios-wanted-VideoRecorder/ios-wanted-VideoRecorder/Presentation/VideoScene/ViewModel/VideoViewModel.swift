//
//  VideoViewModel.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/07.
//

import Foundation

struct VideoViewModel {
    let video: Video
    
    var url: URL? {
        return video.videoURL
    }
    
    init(video: Video) {
        self.video = video
    }
}
