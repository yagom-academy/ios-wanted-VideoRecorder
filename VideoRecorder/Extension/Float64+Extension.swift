//
//  CMTime+Extension.swift
//  VideoRecorder
//
//  Created by sole on 2022/10/14.
//

import Foundation

extension Float64 {
    var string: String {
        let seconds = self.rounded()
        let minutes = (seconds/60).rounded()
        let hours = (minutes/60).rounded()
        if hours > 0 {
            return String(format: "%.0f:%.0f:%.0f", hours, minutes, seconds)
        }
        if hours < 0 && minutes > 0 {
            return String(format: "%0f:%.0f", minutes, seconds)
        }
        return String(format: "00:%.0f", seconds)
    }
}
