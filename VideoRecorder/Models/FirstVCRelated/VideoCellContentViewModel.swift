//
//  VideoCellContentView.swift
//  VideoRecorder
//
//  Created by pablo.jee on 2022/10/11.
//

import Foundation

class VideoCellContentViewModel {
    // TODO: 영상파일 --> 이미지 만들기 같은 그런식으로 만들어서 이미지 보일 수 있도록 추가 처리
    var imageURL: String?
    var videoFileURL: String?
    var name: String
    var date: String
    var duration: String
    
    init() {
        self.name = ""
        self.date = ""
        self.duration = ""
        self.imageURL = ""
        self.videoFileURL = ""
    }
}
