//
//  VideoPlayButton.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/08.
//

import SwiftUI

struct VideoPlayButton: View {
    @ObservedObject var viewModel: VideoViewModel
    var body: some View {
        Button {
            viewModel.isPlaying.toggle()
        } label: {
            if viewModel.isPlaying {
                Image(systemName: "pause.fill")
                    .resizable()
                    .frame(width: 32, height: 32, alignment: .center)
            } else {
                Image(systemName: "play.fill")
                    .resizable()
                    .frame(width: 32, height: 32, alignment: .center)
            }
        }
    }
}

struct VideoPlayButton_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayButton(viewModel: VideoViewModel(video: Video(title: "123", date: Date(), videoLength: "12:03")))
    }
}
