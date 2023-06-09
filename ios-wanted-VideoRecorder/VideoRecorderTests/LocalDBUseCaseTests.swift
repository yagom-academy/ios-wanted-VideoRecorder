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
        sut = LocalDBUseCase<VideoObject>()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

}
