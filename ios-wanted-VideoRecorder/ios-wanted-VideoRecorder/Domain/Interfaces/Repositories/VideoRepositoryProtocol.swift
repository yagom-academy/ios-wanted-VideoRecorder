//
//  VideoRepositoryProtocol.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/10.
//
import Combine

protocol VideoRepositoryProtocol {
    func fetchVideo() -> AnyPublisher<[VideoEntity], Error>
    func createdVideo(_ videoEntity: VideoEntity) -> AnyPublisher<VideoEntity, Error>
}
