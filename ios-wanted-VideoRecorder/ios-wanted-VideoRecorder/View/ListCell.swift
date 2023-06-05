//
//  ListCell.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import SwiftUI

struct ListCell: View {
    let video: Video
    
    var body: some View {
        HStack {
            Image(uiImage: video.image ?? UIImage(systemName: "play.slash.fill")!)
            
            VStack(alignment: .leading) {
                Text("\(video.title)")
                    .font(.title3)
                    .bold()
                
                Text("\(video.date.cellText)")
                    .font(.system(size: 14, weight: .thin))
            }
        }
    }
}

struct ListCell_Previews: PreviewProvider {
    static var previews: some View {
        ListCell(video: Sample().videos[0])
    }
}
