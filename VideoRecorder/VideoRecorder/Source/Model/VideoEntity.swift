//
//  VideoEntity.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/08.
//

import Foundation

struct VideoEntity: Hashable, DataAccessObject {
    let identifier: UUID
    let imageURL: URL
    let title: String
    let date: String
    
    init(identifier: UUID = UUID(), imageURL: URL, title: String, date: String) {
        self.identifier = identifier
        self.imageURL = imageURL
        self.title = title
        self.date = date
    }
}
