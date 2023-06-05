//
//  MainListCell.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import SwiftUI

struct MainListCell: View {
    
    var video: Video
    
    var body: some View {
        HStack(spacing: 20) {
            ThumbnailImage(video: video)
            
            VStack(alignment: .leading) {
                Text(video.title)
                    .font(.title3)
                    .lineLimit(1)
                Text(video.date.cellText)
                    .font(.callout)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "ellipsis")
            Image(systemName: "chevron.right")
        }
        .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 0))
    }
}

struct MainListCell_Previews: PreviewProvider {
    static var previews: some View {
        MainListCell(video: Sample().videos[0])
    }
}
