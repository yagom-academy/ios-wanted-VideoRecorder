//
//  File.swift
//  VideoRecorder
//
//  Created by CodeCamper on 2022/10/11.
//

import Foundation

enum VideoManagerError: Error {
    case thumbnailGenerationError
    
    var localizedDescription: String {
        switch self {
        case .thumbnailGenerationError: return "썸네일 생성에 실패하였습니다"
        }
    }
}
