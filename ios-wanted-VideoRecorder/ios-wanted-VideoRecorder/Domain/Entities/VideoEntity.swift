//
//  Video.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/07.
//

import Foundation

struct VideoEntity: Identifiable {
    var thumbnail: Data
    var name: String
    var date: Date
    var videoURL: URL
    var duration: String
    var id: UUID
}
