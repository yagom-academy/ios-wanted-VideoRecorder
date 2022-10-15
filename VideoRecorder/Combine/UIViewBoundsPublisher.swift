//
//  UIViewBoundsPublisher.swift
//  VideoRecorder
//
//  Created by 한경수 on 2022/10/13.
//

import Foundation
import UIKit
import Combine

extension UIView {
    func bounds() -> UIViewBoundsPublisher {
        return .init(view: self)
    }
}

struct UIViewBoundsPublisher: Publisher {
    typealias Output = CGRect
    typealias Failure = Never
    
    private let view: UIView
    
    init(view: UIView) {
        self.view = view
    }
    
    func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, CGRect == S.Input {
        let subscription = UIViewBoundsSubscription(
            subscriber: subscriber,
            view: view)
        subscriber.receive(subscription: subscription)
    }
}

class UIViewBoundsSubscription<S: Subscriber>: Subscription where S.Input == CGRect, S.Failure == Never {
    private var subscriber: S?
    private var boundsObserver: NSKeyValueObservation?
    private var view: UIView
    
    init(subscriber: S? = nil, view: UIView) {
        self.subscriber = subscriber
        self.view = view
        self.boundsObserver = self.view.observe(\.layer.bounds, options: [.new], changeHandler: { object, change in
            guard let newValue = change.newValue else { return }
            _ = self.subscriber?.receive(newValue)
        })
        
    }
    
    func request(_ demand: Subscribers.Demand) { }
    
    func cancel() {
        subscriber = nil
        boundsObserver?.invalidate()
    }
}
