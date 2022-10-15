//
//  Publisher+Extension.swift
//  VideoRecorder
//
//  Created by CodeCamper on 2022/10/14.
//

import Foundation
import Combine

extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(to path: ReferenceWritableKeyPath<Root, Output?>, on root: Root) -> AnyCancellable {
        sink { [weak root] in root?[keyPath: path] = $0 }
    }
}
