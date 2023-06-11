//
//  UIButton+Combine.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/09.
//
import UIKit
import Combine

extension UIButton {
    var buttonPublisher: AnyPublisher<Void, Never> {
        publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
    }
}
