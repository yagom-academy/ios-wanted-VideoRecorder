//
//  StopCircle.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/06.
//

import SwiftUI

struct StopCircle: View {
    
    @ObservedObject var viewModel: CameraViewModel
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 3)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .padding()
                
                Rectangle()
                    .foregroundColor(.red)
                    .frame(width: 30, height: 30)
            }
            
            Text(String(format: "%02d:%02d", viewModel.minute, viewModel.second))
                .font(.body)
                .foregroundColor(.white)
        }
    }
}

struct StopCircle_Previews: PreviewProvider {
    static var previews: some View {
        StopCircle(viewModel: CameraViewModel())
    }
}
