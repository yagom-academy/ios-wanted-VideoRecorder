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
            Slider(value: viewModel.$videoTime)
            HStack {
                Text("00:00")
                Spacer()
                Text("12:30")
            }
        }
    }
}

struct VideoSlider_Previews: PreviewProvider {
    static var previews: some View {
        VideoSlider(viewModel: VideoViewModel(video: Video(title: "123", date: Date(), videoLength: "12:03")))
    }
}
