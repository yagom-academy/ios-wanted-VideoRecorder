//
//  FetchVideoUseCase.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/10.
//
import Combine

final class FetchVideoUseCase: FetchVideoUseCaseProtocol {
    private let videoRepository: VideoRepositoryProtocol
    init(videoRepository: VideoRepositoryProtocol) {
        self.videoRepository = videoRepository
    }
    
    func fetchVideo() -> AnyPublisher<[VideoEntity], Error> {
        return videoRepository.fetchVideo()
    }
}
