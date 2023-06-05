//
//  StopCircle.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import SwiftUI

struct StopCircle: View {
    var body: some View {
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
    }
}

struct StopCircle_Previews: PreviewProvider {
    static var previews: some View {
        StopCircle()
    }
}
