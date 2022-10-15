//
//  BackgroundTaskManager.swift
//  VideoRecorder
//
//  Created by 김지인 on 2022/10/14.
//

import UIKit
import BackgroundTasks

class BackgroundFetch: NSObject {
    static let shared = BackgroundFetch()
    private var backgroundTaskIdentifiers = [UIBackgroundTaskIdentifier]()
    
    func beginBackgroundTask(_ callback: (UIBackgroundTaskIdentifier) -> Void) {
        var backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask(identifier: backgroundTaskIdentifier)
        }
        self.backgroundTaskIdentifiers.append(backgroundTaskIdentifier)
        callback(backgroundTaskIdentifier)
    }
    
    func endAllBackgroundTask() {
        let identifiers = self.backgroundTaskIdentifiers
        self.backgroundTaskIdentifiers.removeAll()
        identifiers.forEach({ UIApplication.shared.endBackgroundTask($0) })
    }
    
    func endBackgroundTask(identifier: UIBackgroundTaskIdentifier) {
        if let index = self.backgroundTaskIdentifiers.firstIndex(where: { $0 == identifier }) {
            self.backgroundTaskIdentifiers.remove(at: index)
        }
        UIApplication.shared.endBackgroundTask(identifier)
    }
}

extension UIBackgroundTaskIdentifier {
    func endBackgroundTask() {
        BackgroundFetch.shared.endBackgroundTask(identifier: self)
    }
}
