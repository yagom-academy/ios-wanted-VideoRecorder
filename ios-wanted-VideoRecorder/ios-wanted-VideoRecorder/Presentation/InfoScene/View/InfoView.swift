//
//  InfoView.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/09.
//

import SwiftUI

struct InfoView: View {
    
    let video: Video
    @State var date: Date = Date()
    
    var body: some View {
        VStack {
            Text("영상 촬영 날짜")
                .font(.title3)
                .bold()
            DatePicker(
                "영상 촬영 날짜",
                selection: Binding<Date>(get: { self.video.date },
                                         set: { self.date = $0 }),
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            
            Spacer()
            
            video.thumbnailImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 200, alignment: .center)
            
            Spacer()
            
            HStack {
                Image(systemName: "doc.text.fill")
                    .bold()
                Text("영상 제목")
                    .bold()
                Spacer()
                Text("\(video.title)")
            }
            
            Spacer()
            
            HStack {
                Image(systemName: "clock.badge.checkmark.fill")
                    .bold()
                Text("영상 시간")
                    .bold()
                Spacer()
                Text("\(video.videoLength)")
            }
            
            Spacer()
            
            HStack {
                Image(systemName: "deskclock.fill")
                    .bold()
                Text("영상 세부 시간")
                    .bold()
                Spacer()
                Text("\(video.date.descText)")
            }
        }
        .navigationTitle("영상 정보")
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 30, trailing: 20))
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(video: Video(id: UUID(), title: "Title", date: Date(), videoURL: nil, videoLength: "12:30"))
    }
}
