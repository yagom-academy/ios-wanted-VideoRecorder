//
//  Date+Extension.swift
//  VideoRecorder
//
//  Created by 신병기 on 2022/10/12.
//

import Foundation

extension Date {
    var dateToFileString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
        return formatter.string(from: self)
    }
}
