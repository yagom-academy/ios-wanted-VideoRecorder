//
//  VideoInterfaceButtons.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/08.
//

import SwiftUI
import AVFoundation

struct VideoInterfaceButtons: View {
    let viewModel: VideoViewModel
    
    var body: some View {
        HStack {
            Button {
                viewModel.moveToBackThreeSecond()
            } label: {
                Image(systemName: "backward.end.fill")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
            }
            
            Spacer()
            
            VideoPlayButton(viewModel: viewModel)
            
            Spacer()
            
            Button {
                // 액티비티 뷰
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .frame(width: 20, height: 25, alignment: .center)
            }
        }
        .foregroundColor(.accentColor)
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
}

struct VideoInterfaceButtons_Previews: PreviewProvider {
    static var previews: some View {
        VideoInterfaceButtons(viewModel: VideoViewModel(video: Video(title: "123", date: Date(), videoLength: "12:03")))
    }
}
