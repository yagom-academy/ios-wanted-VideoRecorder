//
//  UIView+Extension.swift
//  VideoRecorder
//
//  Created by sole on 2022/10/11.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
