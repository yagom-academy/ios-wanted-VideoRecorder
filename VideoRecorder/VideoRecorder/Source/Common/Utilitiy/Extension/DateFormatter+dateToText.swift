//
//  DateFormatter+dateToText.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/08.
//

import Foundation

extension DateFormatter {
    static let dateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        return dateFormatter
    }()
    
    static func dateToText(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
