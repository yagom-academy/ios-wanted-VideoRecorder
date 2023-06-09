//
//  VideoInfo.swift
//  VideoRecorder
//
//  Created by Hyejeong Jeong on 2023/06/07.
//

import Foundation
import UIKit

struct VideoInfo: Hashable {
    let id: UUID
    let videoURL: URL
    let thumbnailImage: UIImage
    let duration: TimeInterval
    let fileName: String
    let registrationDate: Date
}
