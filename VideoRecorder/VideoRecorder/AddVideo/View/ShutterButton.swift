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
        
        let innerCircleRect = CGRect(x: bounds.origin.x + 15,
                                     y: bounds.origin.y + 15,
                                     width: bounds.size.width - 30,
                                     height: bounds.size.height - 30)
        let innerCirclePath = UIBezierPath(roundedRect: innerCircleRect, cornerRadius: innerCircleRect.size.width / 2.0)
        
        outerCirclePath.addClip()
        
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(outerCircleRect)
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(12.0)
        context.strokeEllipse(in: outerCircleRect)
        
        innerCirclePath.addClip()
        
        context.setFillColor(UIColor.red.cgColor)
        context.fill(innerCircleRect)
    }
}
