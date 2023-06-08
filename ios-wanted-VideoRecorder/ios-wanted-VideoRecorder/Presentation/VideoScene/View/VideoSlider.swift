//
//  VideoSlider.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/08.
//

import SwiftUI

struct VideoSlider: View {
    @ObservedObject var viewModel: VideoViewModel
    
    var body: some View {
        VStack {
            Slider(value: $viewModel.videoTimeRatio, in: 0...1)
            HStack {
                Text("\(viewModel.currentTime)")
                Spacer()
                Text("\(viewModel.durationTime)")
            }
        }
    }
}

struct VideoSlider_Previews: PreviewProvider {
    static var previews: some View {
        VideoSlider(viewModel: VideoViewModel(video: Video(title: "123", date: Date(), videoLength: "12:03")))
    }
}
