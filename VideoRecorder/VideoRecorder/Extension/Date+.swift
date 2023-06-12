//
//  Date+.swift
//  VideoRecorder
//
//  Created by Hyejeong Jeong on 2023/06/09.
//

import Foundation

extension Date {
    static let formatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? Locale.current.identifier)
        return formatter
    }()
    
    func translateDayFormat() -> String {
        Date.formatter.dateFormat = "yyyy-MM-dd"
        return Date.formatter.string(from: self)
    }
    
    func translateTimeFormat() -> String {
        Date.formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return Date.formatter.string(from: self)
    }
}
