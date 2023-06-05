//
//  CameraInterfaceView.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import SwiftUI

struct CameraInterfaceView: View {
    
    var body: some View {
        ZStack {
        }
        .frame(width: 300, height: 150, alignment: .center)
        .background(.black)
        .opacity(0.3)
        .cornerRadius(20)
        .overlay(alignment: .center) {
            HStack(spacing: 60) {
                Image(systemName: "photo.fill")
                
                Circle()
                    .frame(width: 50, height: 50, alignment: .center)
                
                Button {
                    // 카메라 앞 뒤 바꾸기
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
        CameraInterfaceView()
    }
}
