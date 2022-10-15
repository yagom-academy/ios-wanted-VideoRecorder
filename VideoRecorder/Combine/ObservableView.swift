//
//  UIView+Combine.swift
//  VideoRecorder
//
//  Created by 한경수 on 2022/10/12.
//

import Foundation
import Combine
import UIKit

class ObservableView: UIView {
    @Published var framePublisher: CGRect = .zero
    
    override func layoutSubviews() {
        super.layoutSubviews()
        framePublisher = self.frame
    }
}
