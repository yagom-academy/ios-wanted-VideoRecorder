//
//  SceneContext.swift
//  VideoRecorder
//
//  Created by sokol on 2022/10/11.
//

import Foundation

class SceneContext<Dependecy> {
    
    var dependency: Dependecy
    
    init(dependency: Dependecy) {
        self.dependency = dependency
    }
}
