//
//  CMTime+formattedTime.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/09.
//

import AVFoundation

extension CMTime {
    private var roundedSeconds: Double {
        return seconds.rounded()
    }
    
    private var hour: Int {
        if roundedSeconds.isFinite && !roundedSeconds.isNaN {
            return Int(roundedSeconds / 3600)
        }
        return 0
    }
    
    private var minute: Int {
        if roundedSeconds.isFinite && !roundedSeconds.isNaN {
            return Int(roundedSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        }
        return 0
    }
    
    private var second: Int {
        if roundedSeconds.isFinite && !roundedSeconds.isNaN {
            return Int(roundedSeconds.truncatingRemainder(dividingBy: 60))
        }
        return 0
    }
    
    var formattedTime: String {
        if hour > 0 {
            return String(format: "%d:%02d:%02d", hour, minute, second)
        }
        
        return String(format: "%02d:%02d", minute, second)
    }
}
