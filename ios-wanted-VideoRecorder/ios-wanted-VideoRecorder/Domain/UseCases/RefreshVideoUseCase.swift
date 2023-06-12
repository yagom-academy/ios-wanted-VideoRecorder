//
//  RefreshVideoUseCase.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/10.
//
import Combine

final class RefreshVideoUseCase: RefreshVideoUseCaseProtocol {
    private let videoRepository: VideoRepositoryProtocol
    init(videoRepository: VideoRepositoryProtocol) {
        self.videoRepository = videoRepository
    }
    
    func refreshVideo() -> PassthroughSubject<VideoEntity, Never> {
        return videoRepository.createdVideo
    }
}
