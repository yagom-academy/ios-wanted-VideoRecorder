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
            Image(uiImage: video.image ?? UIImage(systemName: "play.slash.fill")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                .cornerRadius(20)
                .overlay(alignment: .bottomLeading) {
                    ZStack {
                        Text("12:03")
                            .foregroundColor(.white)
                    }
                    .background(.black)
                    .cornerRadius(5)
                    .opacity(0.6)
                    .offset(x: 5, y: -5)
                }
                .frame(width: 80, height: 70, alignment: .center)
        }
        .shadow(radius: 5, x: 2, y: 3)
    }
}

struct ThumbnailImage_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailImage(video: Sample().videos[0])
    }
}
