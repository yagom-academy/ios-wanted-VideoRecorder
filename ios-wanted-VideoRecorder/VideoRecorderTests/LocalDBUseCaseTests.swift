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

    func test_2개를_저장할경우_2개가_저장된다() throws {
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

}
