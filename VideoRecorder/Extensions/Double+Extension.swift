//
//  String+Extension.swift
//  VideoRecorder
//
//  Created by 한경수 on 2022/10/13.
//

import Foundation

extension Double {
    func convertToTimeFormat() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: TimeInterval(self))!
    }
}
