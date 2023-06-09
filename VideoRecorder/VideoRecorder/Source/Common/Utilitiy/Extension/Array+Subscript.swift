//
//  Array+Subscript.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/09.
//

extension Array {
    subscript (safe index: Int) -> Element? {
        get {
            return indices ~= index ? self[index] : nil
        }
        set {
            guard let newValue,
                  indices ~= index else { return }
            
            self[index] = newValue
        }
    }
}
