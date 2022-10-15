//
//  FirebaseManagerError.swift
//  VideoRecorder
//
//  Created by CodeCamper on 2022/10/12.
//

import Foundation

enum FirebaseManagerError: Error {
    case loadError
    var localizedDescription: String {
        switch self {
        case .loadError: return "파이어베이스에서 영상을 로드하던 중 알 수 없는 오류가 발생했습니다."
        }
    }
}
