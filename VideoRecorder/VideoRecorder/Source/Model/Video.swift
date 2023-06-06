//
//  Video.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/06.
//

import UIKit

struct Video: Hashable {
    let identifier = UUID()
    let image: UIImage
    let description: Description
    
    init(image: UIImage, title: String, date: String) {
        self.image = image
        self.description = Description(title: title, date: date)
    }
    
    struct Description: Hashable {
        let identifier = UUID()
        let title: String
        let date: String
    }
}
