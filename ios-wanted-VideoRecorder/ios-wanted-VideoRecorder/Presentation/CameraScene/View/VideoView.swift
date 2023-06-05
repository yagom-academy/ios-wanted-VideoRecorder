//
//  VideoView.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/06.
//

import SwiftUI

struct VideoView: View {
    
    var image: CGImage?
    
    var body: some View {
        if let image = image {
            Image(image, scale: 1.0, orientation: .up, label: Text("Camera"))
                .ignoresSafeArea()
        } else {
            Text("카메라 권한이 없습니다.")
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView()
    }
}
