//
//  VideoView.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/07.
//

import SwiftUI
import AVKit

struct VideoView: View {
    
    let viewModel: VideoViewModel
    
    init(viewModel: VideoViewModel) {
        self.viewModel = viewModel
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.label]
        UINavigationBar.appearance().backgroundColor = .systemBackground
    }
    
    var body: some View {
        NavigationStack {
            VideoPlayer(player: viewModel.videoPlayer, videoOverlay: {
                VStack {
                    Spacer()
                    VideoInterfaceView(viewModel: viewModel)
                }
                .frame(alignment: .bottom)
            })
            .ignoresSafeArea(.all, edges: .bottom)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .navigationTitle(viewModel.video.title)
        .toolbar {
            NavigationLink {
                InfoView(video: viewModel.video)
            } label: {
                Image(systemName: "info.circle.fill")
            }
        }
        .foregroundColor(Color(UIColor.label))
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(viewModel: VideoViewModel(video: Video(title: "abc", date: Date(), videoLength: "12:03")))
    }
}
