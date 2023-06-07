//
//  VideoListViewModel.swift
//  VideoRecorder
//
//  Created by Rowan on 2023/06/07.
//

import Foundation
import Combine

protocol EventHandleable {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

final class VideoListViewModel: EventHandleable {
    struct Input { }
    struct Output { }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
