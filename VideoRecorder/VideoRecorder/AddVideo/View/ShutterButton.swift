//
//  ShutterButton.swift
//  VideoRecorder
//
//  Created by Hyejeong Jeong on 2023/06/09.
//

import UIKit

final class ShutterButton: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let outerCircleRect = CGRect(x: bounds.origin.x,
                                     y: bounds.origin.y,
                                     width: bounds.size.width,
                                     height: bounds.size.height)
        let outerCirclePath = UIBezierPath(roundedRect: outerCircleRect,
                                           cornerRadius: outerCircleRect.size.width / 2.0)
        
        outerCirclePath.addClip()
        
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(outerCircleRect)
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(8.0)
        context.strokeEllipse(in: outerCircleRect)
        
        if isSelected {
            let innerCircleRect = CGRect(x: bounds.origin.x + 10,
                                         y: bounds.origin.y + 10,
                                         width: bounds.size.width - 20,
                                         height: bounds.size.height - 20)
            let innerCirclePath = UIBezierPath(roundedRect: innerCircleRect, cornerRadius: innerCircleRect.size.width / 2.0)
            
            innerCirclePath.addClip()
            
            context.setFillColor(UIColor.red.cgColor)
            context.fill(innerCircleRect)
        }
    }
}
