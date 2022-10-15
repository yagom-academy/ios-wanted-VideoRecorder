//
//  CacheManager.swift
//  VideoRecorder
//
//  Created by 권준상 on 2022/10/15.
//

import UIKit

class CacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}

}
