//
//  RecordingButton.swift
//  VideoRecoder
//
//  Created by kimseongjun on 2023/06/08.
//

import UIKit

class RecordingButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        guard let myContext = UIGraphicsGetCurrentContext() else { return }
        
        let height = bounds.height
        let width = bounds.width
        let whiteCircleFrame = bounds.insetBy(dx: width * 0.05, dy: height * 0.05)
        let redCircleFrame = bounds.insetBy(dx: width * 0.15, dy: height * 0.15)
        
        if isSelected {
            myContext.setStrokeColor(UIColor.white.cgColor)
            myContext.setLineWidth(5)
            myContext.addEllipse(in: whiteCircleFrame)
            myContext.drawPath(using: .stroke)
            myContext.closePath()
            
            myContext.setFillColor(UIColor.red.cgColor)
            myContext.addRect(CGRect(x: width * 0.3, y: height * 0.3, width: width * 0.4, height: height * 0.4))
            myContext.drawPath(using: .fill)
            myContext.closePath()
        } else {
            myContext.setStrokeColor(UIColor.white.cgColor)
            myContext.setLineWidth(5)
            myContext.addEllipse(in: whiteCircleFrame)
            myContext.drawPath(using: .stroke)
            myContext.closePath()
            
            myContext.setFillColor(UIColor.red.cgColor)
            myContext.addEllipse(in: redCircleFrame)
            myContext.drawPath(using: .fill)
            myContext.closePath()
        }
    }
}
