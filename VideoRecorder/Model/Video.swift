//
//  Video.swift
//  VideoRecorder
//
//  Created by sole on 2022/10/11.
//

import UIKit

struct Video: Hashable {
    private let identifier = UUID()
    let name: String
    let thumbnail: UIImage
    let runningTime: String
    let date: String
    
    static func == (lhs: Video, rhs: Video) -> Bool {
        lhs.identifier == rhs.identifier
    }
}
