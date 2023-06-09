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
        self.title = title
        self.date = date
    }
}

extension Video {
    func copyWithoutImage() -> Video {
        return Video(data: nil, title: self.title, date: self.date)
    }
}

extension Video {
    typealias DataAccessObject = VideoEntity
    
    static func getModels(from dataList: [DataAccessObject]) -> [Video] {
        var videoList = [Video]()
        
        dataList.forEach { videoEntity in
            guard let identifier = videoEntity.identifier,
                  let data = videoEntity.data,
                  let title = videoEntity.title,
                  let date = videoEntity.date else { return }
            
            let video = Video(identifier: identifier,
                              data: data,
                              title: title,
                              date: date)
            
            videoList.append(video)
        }
        
        return videoList
    }
}
