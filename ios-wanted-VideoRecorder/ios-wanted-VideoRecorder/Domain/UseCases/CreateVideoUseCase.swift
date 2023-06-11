//
//  CreateVideoUseCase.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/10.
//
import Combine

final class CreateVideoUseCase: CreateVideoUseCaseProtocol {
    private let videoRepository: VideoRepositoryProtocol
    init(videoRepository: VideoRepositoryProtocol) {
        self.videoRepository = videoRepository
    }
    
    func createVideo(_ videoEntity: VideoEntity) -> AnyPublisher<VideoEntity, Error> {
        return videoRepository.createVideo(videoEntity)
    }
}
