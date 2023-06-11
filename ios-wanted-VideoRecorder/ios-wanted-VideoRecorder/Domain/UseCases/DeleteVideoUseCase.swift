//
//  DeleteVideoUseCase.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/11.
//
import Combine
import Foundation

final class DeleteVideoUseCase: DeleteVideoUseCaseProtocol {
    private let videoRepository: VideoRepositoryProtocol
    
    init(videoRepository: VideoRepositoryProtocol) {
        self.videoRepository = videoRepository
    }
    
    func deleteVideo(videoID id: UUID) -> AnyPublisher<VideoEntity?, Error> {
        return videoRepository.deleteVideoEntity(videoID: id)
    }
}
