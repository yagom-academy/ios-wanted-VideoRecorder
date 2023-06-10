//
//  Double+Extension.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/10.
//

import Foundation

extension Double {
    func format(units: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.zeroFormattingBehavior = [.pad]
        
        return formatter.string(from: self)
    }
}
