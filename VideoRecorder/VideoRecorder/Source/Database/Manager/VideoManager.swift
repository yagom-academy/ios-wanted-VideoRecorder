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
        Video(image: .actions, title: "222222", date: "222222"),
        Video(image: .checkmark, title: "333333", date: "333333"),
        Video(image: .remove, title: "444444", date: "444444"),
        Video(image: .strokedCheckmark, title: "555555", date: "555555"),
        Video(image: .add, title: "666666", date: "666666"),
        Video(image: .actions, title: "777777", date: "777777"),
        Video(image: .checkmark, title: "888888", date: "888888"),
        Video(image: .remove, title: "999999", date: "999999"),
        Video(image: .strokedCheckmark, title: "10", date: "10"),
        Video(image: .add, title: "11", date: "11"),
        Video(image: .actions, title: "12", date: "12")
    ]
}
