//
//  VideoPlayerViewModelTests.swift
//  UnitTests
//
//  Created by CodeCamper on 2022/10/14.
//

import Foundation
import XCTest
import Combine
@testable import VideoRecorder

class VideoPlayerViewModelTests: XCTestCase {
    var viewModel: VideoPlayerViewModel!
    var subscriptions = [AnyCancellable]()
    typealias Action = VideoPlayerViewModel.Action
    
    override func setUpWithError() throws {
        let metaData = DummyGenerator.dummyVideoMetaData()!
        guard let videoURL = Bundle(for: type(of: self)).url(forResource: "SampleVideo", withExtension: "mp4") else { return }
        try? Data(contentsOf: videoURL).write(to: metaData.videoPath!)
        viewModel = VideoPlayerViewModel(metaData: metaData)
        
        let waitForLoad = self.expectation(description: "Video Loading")
        viewModel.player.publisher(for: \.currentItem)
            .filter { $0 != nil }
            .sink { _ in
                waitForLoad.fulfill()
            }.store(in: &subscriptions)
        waitForExpectations(timeout: 20)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        subscriptions = []
    }
    
    func test_toggleIsPlaying() {
        // given
        let previousState = viewModel.player.timeControlStatus
        
        // when
        viewModel.action.send(Action.toggleIsPlaying)
        
        // then
        XCTAssertNotEqual(previousState, viewModel.player.timeControlStatus)
    }
    
    func test_setIsPlaying() {
        // given
        let previous = viewModel.player.timeControlStatus
        
        // when
        viewModel.action.send(Action.setIsPlaying(!(previous == .playing || previous == .waitingToPlayAtSpecifiedRate)))
        
        // then
        XCTAssertNotEqual(viewModel.player.timeControlStatus, previous)
    }
    
    func test_seekToCurrentTime() {
        // given
        viewModel.currentTime = 12.0
        XCTAssertNotEqual(viewModel.player.currentTime().seconds, 12.0)
        
        // when
        viewModel.action.send(Action.seekToCurrentTime)
        
        // then
        XCTAssertEqual(viewModel.player.currentTime().seconds, 12.0)
    }
    
    func test_updateCurrentTimeWithProgress() {
        // given
        let duration = viewModel.metaData.videoLength
        
        // when
        viewModel.action.send(Action.updateCurrentTimeWithProgress(0.5))
        
        // then
        let expected = duration * 0.5
        XCTAssertEqual(viewModel.currentTime, expected)
    }
    
    func test_rewind() {
        // given
        viewModel.action.send(Action.updateCurrentTimeWithProgress(0.5))
        viewModel.action.send(Action.seekToCurrentTime)
        XCTAssertNotEqual(viewModel.player.currentTime().seconds, .zero)
        
        // when
        viewModel.action.send(Action.rewind)
        
        // then
        XCTAssertEqual(viewModel.player.currentTime().seconds, .zero)
    }
    
    func test_setIsEditingCurrentTime() {
        // given
        let previous = viewModel.isEditingCurrentTime
        
        // when
        viewModel.action.send(Action.setIsEditingCurrentTime(!previous))
        
        // then
        XCTAssertNotEqual(previous, viewModel.isEditingCurrentTime)
    }
}
