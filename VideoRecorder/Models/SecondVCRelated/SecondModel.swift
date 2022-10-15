//
//  SecondModel.swift
//  VideoRecorder
//
//  Created by sokol on 2022/10/11.
//

import Foundation

class SecondModel {
    
    //input
    var didReceiveDoneRecoding = { }
    
    //output
    @MainThreadActor var routeSubject: ( (SceneCategory) -> () )?
    
    //properties
    // TODO: associated type과 관련된 any 키워드 --> 리팩토링
    private var repository: any RepositoryProtocol
    
    init(repository: any RepositoryProtocol) {
        self.repository = repository
        bind()
    }
    
    private func bind() {
        didReceiveDoneRecoding = { [weak self] in
            guard let self = self else { return }
            let context = SceneContext(dependency: FirstSceneAction.refresh)
            self.routeSubject?(.closeWithAction(.main(.firstViewControllerWithAction(context: context))))
        }
    }
    
}
