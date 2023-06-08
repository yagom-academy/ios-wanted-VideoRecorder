//
//  VideoInterfaceView.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/08.
//

import SwiftUI
import AVFoundation

struct VideoInterfaceView: View {
    let viewModel: VideoViewModel
    
    var body: some View {
        ZStack {
        }
        .frame(width: 300, height: 150, alignment: .center)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .background(.black)
        .opacity(0.3)
        .cornerRadius(20)
        .overlay(alignment: .center) {
            VStack {
                VideoSlider(viewModel: viewModel)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                VideoInterfaceButtons(viewModel: viewModel)
            }
        }
    }
}

struct VideoInterfaceView_Previews: PreviewProvider {
    static var previews: some View {
        VideoInterfaceView(viewModel: VideoViewModel(video: Video(title: "123", date: Date(), videoLength: "12:03")))
    }
}
