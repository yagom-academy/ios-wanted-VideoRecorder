//
//  DataTransferObject.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/08.
//

import Foundation

protocol DataTransferObject {
    associatedtype DataAccessObject
    
    var identifier: UUID { get }
    
    static func getModels(from dataList: [DataAccessObject]) -> [Self]
}
