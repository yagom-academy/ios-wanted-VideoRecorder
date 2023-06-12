//
//  VideoInfo.swift
//  VideoRecorder
//
//  Created by Hyejeong Jeong on 2023/06/07.
//

import Foundation

struct VideoInfo: Hashable {
    let id: UUID
    let videoURL: URL
    let thumbnailImage: Data
    let duration: TimeInterval
    let fileName: String
    let registrationDate: Date
}
