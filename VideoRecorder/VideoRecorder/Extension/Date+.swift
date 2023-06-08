//
//  Date+.swift
//  VideoRecorder
//
//  Created by Hyejeong Jeong on 2023/06/09.
//

import Foundation

extension Date {
    func translateLocalizedFormat() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? Locale.current.identifier)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
