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
        HStack {
            ThumbnailImage(video: video)
                .frame(width: 100, height: 90, alignment: .center)
            
            VStack(alignment: .leading) {
                Text(video.title)
                    .font(.title3)
                
                Text(video.date.cellText)
                    .font(.callout)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct MainListCell_Previews: PreviewProvider {
    static var previews: some View {
        MainListCell(video: Sample().videos[0])
    }
}
