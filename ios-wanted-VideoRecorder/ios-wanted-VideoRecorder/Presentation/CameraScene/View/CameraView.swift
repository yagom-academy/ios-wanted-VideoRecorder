//
//  CameraView.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
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
                    viewModel.disconnectCaptureSession()
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
            VideoView(image: viewModel.cameraFrame)
        })
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
