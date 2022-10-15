//
//  Extension+Int.swift
//  VideoRecorder
//
//  Created by Subin Kim on 2022/10/13.
//

import Foundation

extension Int {
    func convertTimeFormat() -> String {
        let hours = self / 3600
        let minutes = self / 60 % 60
        let seconds = self % 60

        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
