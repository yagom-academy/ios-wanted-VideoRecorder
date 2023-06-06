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
                .frame(width: 100, height: 90, alignment: .center)
                .cornerRadius(20)
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                .overlay(alignment: .bottomLeading) {
                    ZStack {
                        Text(video.videoLength)
                            .foregroundColor(.white)
                    }
                    .background(.black)
                    .cornerRadius(5)
                    .opacity(0.6)
                    .offset(x: 5, y: -5)
                }
        }
        .shadow(radius: 3, x: 2, y: 3)
    }
}

struct ThumbnailImage_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailImage(video: Sample().videos[0])
    }
}
