//
//  UICollectionViewCell+ReuseIdentifying.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/06.
//

import UIKit

public protocol ReuseIdentifying {}

extension ReuseIdentifying {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReuseIdentifying {}
