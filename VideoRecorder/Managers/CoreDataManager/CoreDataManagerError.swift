//
//  File.swift
//  VideoRecorder
//
//  Created by CodeCamper on 2022/10/11.
//

import Foundation

enum CoreDataManagerError: Error {
    case entityError
    
    var localizedDescription: String {
        switch self{
        case .entityError: return "엔터티를 찾을 수 없습니다"
        }
    }
}
