//
//  Array.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/08.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        get {
            return indices ~= index ? self[index] : nil
        }
        set(newValue) {
            if let value = newValue, self.indices ~= index {
                self[index] = value
            }
        }
    }
}
