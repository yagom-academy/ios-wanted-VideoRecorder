//
//  CameraInterfaceView.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/06.
//

import SwiftUI

struct CameraInterfaceView: View {
    
    @ObservedObject var viewModel: CameraViewModel
    
    var body: some View {
        ZStack {
        }
        .frame(width: 300, height: 150, alignment: .center)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .background(.black)
        .opacity(0.3)
        .cornerRadius(20)
        .overlay(alignment: .center) {
            HStack(spacing: 60) {
                Image(systemName: "photo.fill")
                
                VStack {
                    Button {
                        viewModel.isRecord.toggle()
                    } label: {
                        if viewModel.isRecord {
                            StopCircle(viewModel: viewModel)
                        } else {
                            PlayCircle()
                        }
                    }
                }
                
                Button {
                    if viewModel.isCameraFronted {
                        viewModel.cameraManager.changeUseCamera()
                        viewModel.isCameraFronted.toggle()
                    } else {
                        viewModel.cameraManager.changeUseCamera()
                        viewModel.isCameraFronted.toggle()
                    }
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                        .foregroundColor(.white)
                }
            }
            .font(.largeTitle)
        }
    }
}

struct CameraInterfaceView_Previews: PreviewProvider {
    static var previews: some View {
        CameraInterfaceView(viewModel: CameraViewModel())
    }
}
