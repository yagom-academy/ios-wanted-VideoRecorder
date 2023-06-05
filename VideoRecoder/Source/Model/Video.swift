//
//  Video.swift
//  VideoRecoder
//
//  Created by kimseongjun on 2023/06/05.
//

import Foundation

struct Video: Hashable, Identifiable {
    let id: UUID
    let title: String
    let date: String
}
