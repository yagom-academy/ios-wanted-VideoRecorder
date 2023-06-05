//
//  CameraView.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import SwiftUI

struct CameraView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    // 이전 창 넘어가기
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .font(.largeTitle)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
            
            Spacer()
            
            CameraInterfaceView()
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
