//
//  TimerManager.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/10.
//

import Foundation
import Combine

final class TimerManager {
    private var timer: Timer?
    @Published var runCount: Double = 0
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countTime), userInfo: nil, repeats: true)
    }
    
    func getRunCountAndStop() -> Double {
        timer?.invalidate()
        
        return runCount
    }
    
    @objc private func countTime() {
        runCount += 1
    }
}
