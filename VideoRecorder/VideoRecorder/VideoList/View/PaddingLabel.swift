//
//  PaddingLabel.swift
//  VideoRecorder
//
//  Created by Hyejeong Jeong on 2023/06/09.
//

import UIKit

final class PaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
}
