//
//  TimeInterval+.swift
//  VideoRecorder
//
//  Created by Hyejeong Jeong on 2023/06/11.
//

import Foundation

extension TimeInterval {
    func formatTime() -> String {
        let currentTime = Int(self)
        let minutes = currentTime / 60
        let seconds = currentTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
