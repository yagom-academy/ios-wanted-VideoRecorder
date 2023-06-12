//
//  IdentifierType.swift
//  VideoRecoder
//
//  Created by kimseongjun on 2023/06/06.
//

import UIKit

public protocol IdentifierType {
    static var identifier: String { get }
}

extension IdentifierType {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: IdentifierType {}

