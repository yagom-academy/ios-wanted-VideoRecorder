//
//  Date+Extension.swift
//  VideoRecorder
//
//  Created by CodeCamper on 2022/10/11.
//

import Foundation

extension Date {
    enum DateFormat: String {
        case fileName = "yyyy-MM-dd-hh-mm-ss"
    }
    
    func asString(_ format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
}
