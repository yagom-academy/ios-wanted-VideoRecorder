//
//  MainListView.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/06.
//

import SwiftUI

struct MainListView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "list.triangle")
                    Text("Video List")
                        .bold()
                    
                    Spacer()
                    
                    Button {
                        viewModel.isShowCameraView.toggle()
                    } label: {
                        Image(systemName: "video.fill.badge.plus")
                            .foregroundColor(.indigo)
                    }
                    .fullScreenCover(isPresented: $viewModel.isShowCameraView,
                                     content: {
                        CameraView()
                    })
                }
                .bold()
                .font(.title3)
                .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                
                List {
                    ForEach(viewModel.videos, id: \.id) { video in
                        NavigationLink {
                            VideoView(viewModel: VideoViewModel(video: video))
                        } label: {
                            MainListCell(video: video)
                                .listRowSeparator(.visible)
                            
                            Spacer()
                            
                            Menu {
                                Button {
                                    viewModel.isPresentAlert = true
                                    viewModel.changeText = video.title
                                    viewModel.targetVideo = video
                                } label: {
                                    Text("제목 변경")
                                }
                                
                                NavigationLink {
                                    InfoView(video: video)
                                } label: {
                                    Text("세부 정보")
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .imageScale(.large)
                            }

                        }
                    }
                    .onDelete(perform: viewModel.deleteVideo(_:))
                }
                .listStyle(.plain)
            }
        }
        .alert("변경할 제목을 입력해주세요", isPresented: $viewModel.isPresentAlert) {
            TextField("\(viewModel.changeText)", text: $viewModel.changeText)
            Button("OK", action: {
                viewModel.updateTitleVideo()
            })
            Button("Cancel", action: { })
                .foregroundColor(.red)
        } message: {
            Text("기존 제목을 삭제하고 새로운 제목을 입력해주세요.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView(viewModel: MainViewModel())
    }
}
