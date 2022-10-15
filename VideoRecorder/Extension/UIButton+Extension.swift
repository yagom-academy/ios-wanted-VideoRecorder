//
//  UIButton+Extension.swift
//  VideoRecorder
//
//  Created by 권준상 on 2022/10/13.
//

import UIKit

extension UIButton {
    func marginImageWithText(margin: CGFloat) {
        let halfSize = margin / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -halfSize, bottom: 0, right: halfSize)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: halfSize, bottom: 0, right: -halfSize)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: halfSize, bottom: 0, right: halfSize)
    }
}
