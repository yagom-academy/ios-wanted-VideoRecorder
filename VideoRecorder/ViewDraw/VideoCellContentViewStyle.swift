//
//  VideoCellContentViewStyle.swift
//  VideoRecorder
//
//  Created by pablo.jee on 2022/10/12.
//

import Foundation
import UIKit

protocol VideoCellContentViewStyle { }

extension VideoCellContentViewStyle {
    var thumbNailImageViewStyle: (UIImageView) -> () {
        {
            $0.layer.cornerRadius = 24
            $0.layer.shadowColor = UIColor(red: 0.271, green: 0.357, blue: 0.388, alpha: 0.2).cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowOffset = CGSize(width: 0, height: 1)
            $0.layer.shadowRadius = 8
            $0.backgroundColor = .red
        }
    }
    
    var videoDurationLabelStyle: (UILabel) -> () {
        {
            $0.textColor = .white
            $0.text = "testtest"
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 8)
            $0.numberOfLines = 1
        }
    }
    
    var nameLabelStyle: (UILabel) -> () {
        {
            $0.textColor = .black
            $0.text = "test"
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.numberOfLines = 1
        }
    }
    
    var dateLabelStyle: (UILabel) -> () {
        {
            $0.textColor = .black
            $0.text = "testsdfsfsdfsdfsdf"
            $0.font = UIFont.systemFont(ofSize: 8)
            $0.numberOfLines = 1
        }
    }
    
    var detailButtonStyle: (UIButton) -> () {
        {
            let image = UIImage(systemName: "rectangle.and.pencil.and.ellipsis")
            $0.setImage(image, for: .normal)
        }
    }
    
    var disclosureButtonStyle: (UIButton) -> () {
        {
            // TODO: 이미지 set
            let image = UIImage(systemName: "chevron.right")
            $0.setImage(image, for: .normal)
        }
    }
}
