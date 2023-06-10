//
//  CGImage+Extension.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/10.
//

import CoreGraphics
import Foundation

extension CGImage {
    func convertToData() -> Data? {
        guard let dataProvider = self.dataProvider,
              let data = CFDataGetBytePtr(dataProvider.data) else { return nil }
        
        let dataSize = CFDataGetLength(dataProvider.data)
        
        return Data(bytes: data, count: dataSize)
    }
}
