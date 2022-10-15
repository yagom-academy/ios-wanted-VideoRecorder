//
//  NSObject+Extension.swift
//  VideoRecorder
//
//  Created by 한경수 on 2022/10/11.
//

import Foundation

extension NSObject {
    static var className: String! {
        String(describing: self).components(separatedBy: ".").last
    }
}
