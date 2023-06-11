//
//  DeleteVideoUseCaseProtocol.swift
//  ios-wanted-VideoRecorder
//
//  Created by brody on 2023/06/11.
//
import Combine
import Foundation

protocol DeleteVideoUseCaseProtocol {
    func deleteVideo(videoID: UUID) -> AnyPublisher<VideoEntity?, Error>
}
