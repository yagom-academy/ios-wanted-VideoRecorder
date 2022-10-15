//
//  Styleable.swift
//  VideoRecorder
//
//  Created by sokol on 2022/10/11.
//

import Foundation
import UIKit

protocol Styleable { }

extension UIView: Styleable { }
extension UIBarButtonItem: Styleable { }
extension UINavigationItem: Styleable { }

extension Styleable {
    @discardableResult func addStyles(style: (Self) -> ()) -> Self {
        style(self)
        return self
    }
}
