//
//  ListCell.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import SwiftUI

struct ListCell: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Nature.mp4")
                    .font(.title3)
                    .bold()
                
                Text("2022-09-22")
                    .font(.system(size: 14, weight: .thin))
            }
        }
    }
}

struct ListCell_Previews: PreviewProvider {
    static var previews: some View {
        ListCell()
    }
}
