//
//  Video.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/07.
//

import Foundation

struct Video: Identifiable {
    var name: String
    var fileExtension: String
    var date: Date
    var url: String
    var duration: String
    var id = UUID()
}
