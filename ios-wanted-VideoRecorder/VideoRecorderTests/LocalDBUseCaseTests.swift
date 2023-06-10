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

        // when
        sut.create(videoObject)
        
        guard let objects = sut.read() else {
            XCTFail("test_create메서드를_통해_저장하는_객체와_read메서드의_반환값_객체는_같다")
            return
        }
        
        let resultValue = objects.compactMap { object in
            return object as? VideoObject
        }
        
        // then
        XCTAssertEqual(exceptionValue, resultValue)
    }
    
    func test_update메서드를_통해_title을_바꿀수있다() {
        // given
        var video = Video(title: "Video Title", date: Date(), videoLength: "00:30")
        let videoObject = Video.toRealmObject(video)
        let exceptionTitle = "Title"
        video.title = exceptionTitle
        
        let editingVideoObject = Video.toRealmObject(video)
        // when
        sut.create(videoObject)
        sut.update(editingVideoObject)
        
        let objects = sut.realm!.objects(VideoObject.self)
        let videoObjects = Array(objects)
        let resultVideoObject = videoObjects.first!
        let resultTitle = resultVideoObject.title
        
        // then
        XCTAssertEqual(editingVideoObject, resultVideoObject)
        XCTAssertEqual(exceptionTitle, resultTitle)
    }

}
