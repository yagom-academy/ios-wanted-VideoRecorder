//
//  RecordVideoViewModel.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/07.
//

import Foundation
import AVFoundation

final class RecordVideoViewModel {
    var isImageButtonTapped: Bool = false
    var isRecordButtonTapped: Bool = false
    var isRotateButtonTapped: Bool = false
    
    var imageURL: URL?
    var title: String?
    var date: String?
}
