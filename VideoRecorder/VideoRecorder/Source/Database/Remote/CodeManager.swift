//
//  CodeManager.swift
//  VideoRecorder
//
//  Created by kokkilE on 2023/06/10.
//

import Foundation

final class CodeManager {
    static let encoder = JSONEncoder()
    
    func encode(_ model: Encodable) -> Data? {
        guard let data = try? CodeManager.encoder.encode(model) else { return nil }
        
        return data
    }
}
