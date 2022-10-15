//
//  UnitTests.swift
//  UnitTests
//
//  Created by CodeCamper on 2022/10/11.
//

import XCTest
import AVKit
@testable import VideoRecorder

final class VideoManagerTest: XCTestCase {
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func test저장_불러오기_삭제() throws {
        // MARK: 저장
        // given
        let url = VideoManager.shared.getVideoURL()!
        let createExpectation = self.expectation(description: "Create Video")
        DispatchQueue.global().async {
            guard let videoURL = Bundle(for: type(of: self)).url(forResource: "SampleVideo", withExtension: "mp4") else { return }
            try? Data(contentsOf: videoURL).write(to: url)
            createExpectation.fulfill()
        }
        waitForExpectations(timeout: 5)
        let saveExpectation = self.expectation(description: "Save Video")
        
        // when
        var resultMetaData: VideoMetaData?
        VideoManager.shared.saveVideo(name: "Test", path: url) { result in
            switch result {
            case .success(let metaData):
                resultMetaData = metaData
            case .failure(let error):
                debugPrint(error.localizedDescription)
                XCTFail("Create Failed")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                // Firebase 업로드 대기
                saveExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 20)
        
        // then
        XCTAssertEqual(resultMetaData?.name, "Test")
        XCTAssertEqual(resultMetaData?.videoPath, url)
        
        // MARK: 불러오기
        // when
        let loadExpectation = self.expectation(description: "Load Videos")
        VideoManager.shared.loadVideos(start: 0) { result in
            switch result {
            case .success(let metaDatas):
                resultMetaData = metaDatas.first
                break
            case .failure(let error):
                debugPrint(error.localizedDescription)
                XCTFail("Load Failed")
            }
            loadExpectation.fulfill()
        }
        waitForExpectations(timeout: 5)
        
        // then
        XCTAssertEqual(resultMetaData?.name, "Test")
        XCTAssertEqual(resultMetaData?.videoPath, url)
        
        // MARK: 삭제
        guard let metaData = resultMetaData else { return XCTFail("No MetaData") }
        let deleteExpectation = self.expectation(description: "Delete Video")
        VideoManager.shared.deleteVideo(data: metaData) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                debugPrint(error.localizedDescription)
                XCTFail("Delete Failed")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // Firebase 삭제 대기
                deleteExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5)
    }
}
