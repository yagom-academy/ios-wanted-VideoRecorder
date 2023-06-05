//
//  RecodeCircle.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import SwiftUI

struct PlayCircle: View {
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 3)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .padding()
                
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.red)
            }
            
            Text("00:00")
                .font(.body)
                .foregroundColor(.white)
        }
    }
}

struct RecodeCircle_Previews: PreviewProvider {
    static var previews: some View {
        PlayCircle()
    }
}
