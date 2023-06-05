//
//  MainViewModel.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import Foundation

final class MainViewModel {
    @Published var videos: [Video] = Sample().videos
}
