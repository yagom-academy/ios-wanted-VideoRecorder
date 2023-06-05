//
//  ContentView.swift
//  ios-wanted-VideoRecorder
//
//  Created by 강민수 on 2023/06/05.
//

import SwiftUI

struct MainListView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(1..<10) { value in
                    Text("\(value)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}
