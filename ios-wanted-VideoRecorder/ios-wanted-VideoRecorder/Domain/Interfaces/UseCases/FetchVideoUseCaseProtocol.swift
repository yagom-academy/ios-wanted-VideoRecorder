//
//  FetchVideoUseCaseProtocol.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/10.
//
import Combine

protocol FetchVideoUseCaseProtocol {
    func fetchVideo() -> AnyPublisher<[VideoEntity], Error>
}
