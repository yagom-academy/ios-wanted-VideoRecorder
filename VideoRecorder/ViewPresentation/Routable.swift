//
//  Routable.swift
//  VideoRecorder
//
//  Created by sokol on 2022/10/11.
//

import Foundation
import UIKit

protocol Scenable { }

protocol Routable {
    func route(to Scene: SceneCategory)
}

protocol SceneBuildable {
    func buildScene(scene: SceneCategory) -> Scenable?
}

extension UIViewController: Scenable { }


