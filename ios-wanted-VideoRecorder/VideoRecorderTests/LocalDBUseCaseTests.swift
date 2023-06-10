//
//  VideoRecorderTests.swift
//  VideoRecorderTests
//
//  Created by 강민수 on 2023/06/09.
//

@testable import ios_wanted_VideoRecorder
import RealmSwift
import XCTest

final class LocalDBUseCaseTests: XCTestCase {
    
    private var sut: LocalDBUseCase<VideoObject>!

    override func setUpWithError() throws {
        var config = Realm.Configuration()
        config.inMemoryIdentifier = "LocalDBUseCaseTests"
        let realm = try! Realm(configuration: config)
        sut = LocalDBUseCase<VideoObject>(realm: realm)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_create메서드를_사용하여_2개를_저장할경우_2개가_저장된다() throws {
        // given
        let oneVideoObject = VideoObject()
        let twoVideoObject = VideoObject()
        let exceptionValue = 2
        
        // when
        sut.create(oneVideoObject)
        sut.create(twoVideoObject)
        
        let resultValue = sut.realm!.objects(VideoObject.self).count
        
        // then
        XCTAssertEqual(exceptionValue, resultValue)
    }
    
    func test_create메서드를_통해_저장하는_객체와_read메서드의_반환값_객체는_같다() {
        // given
        let videoObject = VideoObject()
        let exceptionValue = [videoObject]
        sut.create(videoObject)
        // when
        guard let objects = sut.read() else {
            XCTFail("저장되지 않음")
            return
        }
        
        let resultValue = objects.compactMap { object in
            return object as? VideoObject
        }
        
        // then
        XCTAssertEqual(exceptionValue, resultValue)
    }

}
