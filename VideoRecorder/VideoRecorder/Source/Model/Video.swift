//
//  Video.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/06.
//

import UIKit

struct Video: Hashable {
    let identifier: UUID
    let image: UIImage
    let title: String
    let date: String
    
    init(identifier: UUID = UUID(), image: UIImage, title: String, date: String) {
        self.identifier = identifier
        self.image = image
        self.title = title
        self.date = date
    }
}

extension Video {
    func copy() -> Video {
        return Video(image: self.image,
                     title: self.title,
                     date: self.date)
    }
}
