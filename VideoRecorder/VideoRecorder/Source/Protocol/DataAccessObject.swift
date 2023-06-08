//
//  DataAccessObject.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/08.
//

import Foundation

protocol DataAccessObject: Identifiable {
    associatedtype DataTransferObject
    
    var identifier: UUID? { get }
    
    func setValues(from model: DataTransferObject)
    func updateValues(from model: DataTransferObject)
}
