//
//  VideoListViewModel.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/10.
//
import Combine
import Foundation

final class VideoListViewModel {
    let videoEntitiesPublisher = CurrentValueSubject<[VideoEntity], Never>([])
    private let fetchVideoUseCase: FetchVideoUseCaseProtocol
    private let refreshVideoUseCase: RefreshVideoUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    struct Input {
        let viewDidLoadEvent: Just<Void>
    }
    
    init(
        fetchVideoUseCase: FetchVideoUseCaseProtocol,
        refreshVideoUseCase: RefreshVideoUseCaseProtocol
    ) {
        self.fetchVideoUseCase = fetchVideoUseCase
        self.refreshVideoUseCase = refreshVideoUseCase
    }
    
    func transform(from input: Input) {
        input.viewDidLoadEvent
            .flatMap { [weak self] _ -> AnyPublisher<[VideoEntity], Error> in
                guard let self else {
                    return Empty().eraseToAnyPublisher()
                }
                return self.fetchVideoUseCase.fetchVideo()
            }
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { videos in
                self.videoEntitiesPublisher.send((videos))
            }
            .store(in: &cancellables)
        
        refreshVideoUseCase.refreshVideo()
            .sink { videoEntity in
                let currentVideoList = self.videoEntitiesPublisher.value
                self.videoEntitiesPublisher.send(currentVideoList + [videoEntity])
            }
            .store(in: &cancellables)
    }
    
    func videoEntity(at index: Int) -> VideoEntity {
        return videoEntitiesPublisher.value[index]
    }
    
    func delete(VideoID: UUID) {
        // 코어데이터로 먼저 지우고 받은 id를 publisher에 주면?
        
    }
}
