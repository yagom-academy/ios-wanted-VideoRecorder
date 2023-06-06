//
//  CameraView.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/06.
//

import SwiftUI

struct CameraView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel = CameraViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .font(.largeTitle)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
            
            Spacer()
            
            CameraInterfaceView(viewModel: self.viewModel)
        }
        .background(content: {
            if viewModel.cameraManager.isCameraPermission {
                VideoView(session: viewModel.cameraManager.session)
                    .ignoresSafeArea()
            } else {
                Text("카메라 권한이 없습니다.")
            }
        })
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
