//
//  DummyMaker.swift
//  VideoRecorder
//
//  Created by pablo.jee on 2022/10/13.
//

import Foundation

class DummyMaker {
    static func getDummyVideoData() -> VideoCellContentViewModel {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        
        let cellModel = VideoCellContentViewModel()
        cellModel.duration = "03:25"
        cellModel.date = "2022/10/10"
        cellModel.name = "name"
        cellModel.imageURL = ""
        cellModel.videoFileURL = ""
        
        return cellModel
    }
    
    static func insertDummyVideoDataToCoreData() {
        
    }
    
    static func removeDummyVideoDataToCoreData() {
        
    }
}
