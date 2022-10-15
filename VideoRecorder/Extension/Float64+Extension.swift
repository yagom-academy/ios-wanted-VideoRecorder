//
//  CMTime+Extension.swift
//  VideoRecorder
//
//  Created by sole on 2022/10/14.
//

import Foundation

extension Float64 {
    var string: String {
        let totalSeconds: Int = Int(self)
        let seconds: Int = Int((totalSeconds % 3600) % 60 )
        let minutes: Int = Int((totalSeconds % 3600) / 60 )
        let hours: Int = Int(totalSeconds / 3600)
        if hours > 0 {
            return String(format:  "%.0d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
