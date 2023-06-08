//
//  RecordVideoViewModel.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/07.
//

import Foundation
import AVFoundation

final class RecordVideoViewModel {
    var imageURL: URL?
    var title: String?
    var date: String?
    
    @Published var isImageButtonTapped: Bool = false
    @Published var isRecordButtonTapped: Bool = false
    @Published var isRotateButtonTapped: Bool = false
}
