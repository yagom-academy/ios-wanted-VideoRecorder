//
//  Date+Extension.swift
//  VideoRecorder
//
//  Created by sole on 2022/10/14.
//

import Foundation

extension Date {
    var string: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
