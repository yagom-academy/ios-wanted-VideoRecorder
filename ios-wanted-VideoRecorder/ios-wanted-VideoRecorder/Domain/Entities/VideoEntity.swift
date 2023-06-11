//
//  VideoEntity.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/07.
//

import Foundation

struct VideoEntity: Identifiable, Equatable {
    var id: UUID
    var name: String
    var date: Date
    var duration: String
    var thumbnail: String
    var videoURL: URL
}
