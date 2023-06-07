//
//  VideoView.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/07.
//

import AVKit
import SwiftUI

struct VideoView: View {
    
    let viewModel: VideoViewModel
    
    var body: some View {
        NavigationStack {
            // 비디오 플레이어
        }
        .navigationTitle(viewModel.video.title)
        .toolbar {
            Button {
                // 비디오 정보
            } label: {
                Image(systemName: "info.circle.fill")
            }

        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(viewModel: VideoViewModel(video: Video(title: "abc", date: Date(), videoLength: "12:03")))
    }
}
