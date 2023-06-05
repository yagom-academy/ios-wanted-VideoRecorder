//
//  Date++Extension.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import Foundation

extension Date {
    private static let cellDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        return dateFormatter
    }()
    
    var cellText: String {
        return Date.cellDateFormatter.string(from: self)
    }
}
