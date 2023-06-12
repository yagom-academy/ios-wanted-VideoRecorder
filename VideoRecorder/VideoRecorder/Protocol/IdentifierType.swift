//
//  IdentifierType.swift
//  VideoRecorder
//
//  Created by Hyejeong Jeong on 2023/06/06.
//

import UIKit

protocol IdentifierType { }

extension IdentifierType {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: IdentifierType { }
