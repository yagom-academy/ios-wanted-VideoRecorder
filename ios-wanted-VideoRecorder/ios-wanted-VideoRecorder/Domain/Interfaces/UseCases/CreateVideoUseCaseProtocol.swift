//
//  CreateVideoUseCaseProtocol.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/10.
//
import Combine

protocol CreateVideoUseCaseProtocol {
    func createVideo(_ videoEntity: VideoEntity) -> AnyPublisher<VideoEntity, Error>
}
