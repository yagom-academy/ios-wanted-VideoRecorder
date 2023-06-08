//
//  VideoManager.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/06.
//

import Combine
import Foundation

final class VideoManager {
    @Published var videoList: [Video] = [
        Video(image: .add, title: "111111", date: Date()),
        Video(image: .actions, title: "222222", date: Date()),
        Video(image: .checkmark, title: "333333", date: Date()),
        Video(image: .remove, title: "444444", date: Date()),
        Video(image: .strokedCheckmark, title: "555555", date: Date()),
        Video(image: .add, title: "666666", date: Date())
    ]
}
