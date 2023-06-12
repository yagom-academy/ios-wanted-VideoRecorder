//
//  ThumbnailImage.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import SwiftUI

struct ThumbnailImage: View {
    
    var video: Video
    
    var body: some View {
        ZStack {
            video.thumbnailImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 60, alignment: .center)
                .cornerRadius(20)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .overlay(alignment: .bottomLeading) {
                    ZStack(alignment: .bottomLeading) {
                        Text(video.videoLength)
                            .foregroundColor(.white)
                    }
                    .background(.black)
                    .cornerRadius(5)
                    .opacity(0.6)
                    .offset(x: 5)
                }
        }
        .shadow(radius: 3, x: 2, y: 3)
    }
}

struct ThumbnailImage_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailImage(video: Video(id: UUID(), title: "title.mov", date: Date(), videoURL: URL(string: "abc"), videoLength: "12:03"))
    }
}
