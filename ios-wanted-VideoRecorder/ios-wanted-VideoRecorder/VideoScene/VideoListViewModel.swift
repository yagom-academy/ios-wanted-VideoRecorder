//
//  VideoListViewModel.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/10.
//
import Combine

final class VideoListViewModel {
    @Published var videoEntities: [VideoEntity] = []
    private let fetchVideoUseCase: FetchVideoUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    struct Input {
        let viewDidLoadEvent: AnyPublisher<Void, Never>
    }
    
    init(fetchVideoUseCase: FetchVideoUseCaseProtocol) {
        self.fetchVideoUseCase = fetchVideoUseCase
    }
    
    func transform(from input: Input) {
        input.viewDidLoadEvent
            .sink {
                self.fetchVideo
            }
    }
}
