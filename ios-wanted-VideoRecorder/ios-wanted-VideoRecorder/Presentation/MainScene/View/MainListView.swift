//
//  ContentView.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import SwiftUI

struct MainListView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "list.triangle")
                Text("Video List")
                    .bold()
                Spacer()
                Button {
                    // 영상 찍기 관련 메서드
                } label: {
                    Image(systemName: "video.fill.badge.plus")
                        .foregroundColor(.indigo)
                }
            }
            .bold()
            .font(.title3)
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
            
            List(viewModel.videos, id: \.id) { video in
                MainListCell(video: video)
                    .listRowSeparator(.visible)
                    .swipeActions(edge: .trailing) {
                        Button {
                            withAnimation(.linear) {
                                viewModel.deleteVideo(video.id)
                            }
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                        .tint(.red)
                    }
            }
            .listStyle(.plain)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView(viewModel: MainViewModel())
    }
}
