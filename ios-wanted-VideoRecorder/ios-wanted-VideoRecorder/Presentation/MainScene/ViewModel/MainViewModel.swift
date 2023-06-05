//
//  MainViewModel.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import Combine
import Foundation

final class MainViewModel: ObservableObject {
    @Published var videos: [Video] = Sample().videos
    
    func deleteVideo(_ id: UUID) {
        guard let index = videos.firstIndex(where: { video in
            return video.id == id
        }) else {
            return
        }
        
        videos.remove(at: index)
    }
}
