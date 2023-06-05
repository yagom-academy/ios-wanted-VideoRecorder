//
//  CameraViewModel.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import Foundation

final class CameraViewModel: ObservableObject {
    
    private var timer: Timer?
    @Published var isRecord: Bool = false {
        willSet {
            if newValue == true {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    self.second += 1
                }
            } else {
                self.timer?.invalidate()
                self.timer = nil
                minute = 0
                second = 0
            }
        }
    }
    @Published var minute: Int = 0
    @Published var second: Int = 0 {
        didSet {
            if second > 59 {
                minute += 1
                second = 0
            }
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}
