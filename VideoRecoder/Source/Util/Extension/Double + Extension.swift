//
//  Double + Extension.swift
//  VideoRecoder
//
//  Created by kimseongjun on 2023/06/09.
//

import Foundation

extension Double {
  func format(units: NSCalendar.Unit) -> String {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .positional
    formatter.allowedUnits = units
    formatter.zeroFormattingBehavior = [ .pad ]
    
    return formatter.string(from: self)!
  }
}
