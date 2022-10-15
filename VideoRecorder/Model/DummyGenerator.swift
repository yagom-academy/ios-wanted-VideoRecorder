//
//  DummyGenerator.swift
//  VideoRecorder
//
//  Created by CodeCamper on 2022/10/14.
//

import Foundation
import UIKit

class DummyGenerator {
    static func dummyVideoMetaData() -> VideoMetaData! {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("SampleVideo.mp4")
        return try? CoreDataManager.shared.createNewVideoMetaData(name: "Sample", createdAt: Date(), videoPath: url, thumbnail: UIImage(named: "sampleThumbnail")!.pngData()!, videoLength: 31.0)
    }
}
