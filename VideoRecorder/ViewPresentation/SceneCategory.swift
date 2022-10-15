//
//  SceneCategory.swift
//  VideoRecorder
//
//  Created by sokol on 2022/10/11.
//

import Foundation

enum SceneCategory {
    case main(mainScene)
    case detail(detailScene)
    case close //아무 액션 없이 그냥 닫기
    //TODO: SceneAction 추가 및 연관처리
    indirect case closeWithAction(SceneCategory)
    case alert(AlertDependency)
    
    enum mainScene {
        case firstViewController(context: SceneContext<FirstModel>)
        case firstViewControllerWithAction(context: SceneContext<FirstSceneAction>)
    }
    
    enum detailScene {
        case secondViewController(context: SceneContext<SecondModel>)
        case thirdViewController(context: SceneContext<ThirdModel>)
    }
    
}
