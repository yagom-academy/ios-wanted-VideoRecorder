//
//  VideoListViewModel.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/10.
//
import Combine

final class VideoListViewModel {
    let videoEntitiesPublisher = CurrentValueSubject<[VideoEntity], Never>([])
    private let fetchVideoUseCase: FetchVideoUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    struct Input {
        let viewDidLoadEvent: Just<Void>
    }
    
    init(fetchVideoUseCase: FetchVideoUseCaseProtocol) {
        self.fetchVideoUseCase = fetchVideoUseCase
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
    }
}
