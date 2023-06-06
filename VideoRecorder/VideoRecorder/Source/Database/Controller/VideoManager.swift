//
//  VideoManager.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/06.
//

import Combine

final class VideoManager {
    @Published var videoList: [Video] = [
        Video(image: .add, title: "111111", date: "111111"),
        Video(image: .add, title: "222222", date: "222222"),
        Video(image: .add, title: "333333", date: "333333"),
        Video(image: .add, title: "444444", date: "444444"),
        Video(image: .add, title: "555555", date: "555555"),
        Video(image: .add, title: "666666", date: "666666")
    ]
}
