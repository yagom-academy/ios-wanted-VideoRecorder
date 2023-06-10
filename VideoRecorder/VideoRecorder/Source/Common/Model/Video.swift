//
//  Video.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/06.
//

import UIKit

struct Video: Hashable, DataTransferObject {
    let identifier: UUID
    let data: Data?
    let title: String
    let date: Date
    
    init(identifier: UUID = UUID(), data: Data?, title: String, date: Date) {
        self.identifier = identifier
        self.data = data
        self.date = date
        
        if title.contains(".mp4") {
            self.title = title
        } else {
            self.title = "\(title).mp4"
        }
    }
}

extension Video: Codable {}
