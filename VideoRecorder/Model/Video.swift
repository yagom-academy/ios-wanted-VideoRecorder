//
//  Video.swift
//  VideoRecorder
//
//  Created by sole on 2022/10/11.
//

import UIKit

struct Video: Codable {
    var identifier = UUID()
    let name: String
    let runningTime: String
    let date: String
    let videoPath: String 
    
    static func == (lhs: Video, rhs: Video) -> Bool {
        lhs.identifier == rhs.identifier
    }
}
