//
//  VideoRepositoryProtocol.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/10.
//
import Combine

protocol VideoRepositoryProtocol {
    var createdVideo: PassthroughSubject<VideoEntity, Never> { get }
    func fetchVideo() -> AnyPublisher<[VideoEntity], Error>
    func createVideo(_ videoEntity: VideoEntity) -> AnyPublisher<VideoEntity, Error>
}
