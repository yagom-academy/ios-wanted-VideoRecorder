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
    
    private static let descDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "YYYY년 MM월 dd일 hh:mm:ss"
        
        return dateFormatter
    }()
    
    var cellText: String {
        return Date.cellDateFormatter.string(from: self)
    }
    
    var descText: String {
        return Date.descDateFormatter.string(from: self)
    }
}
