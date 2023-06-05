//
//  ContentView.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import SwiftUI

struct MainListView: View {
    var videoLists = Sample().videos
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "list.triangle")
                Text("Video List")
                    .bold()
                
                Spacer()
                
                Button {
                } label: {
                    Image(systemName: "video.fill.badge.plus")
                        .foregroundColor(.indigo)
                }
            }
            .bold()
            .font(Font(.init(.menuTitle, size: 18)))
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
            
            List {
                ForEach(videoLists) { video in
                    Text("abc")
                }
            }
            .listStyle(.plain)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}
