//
//  floatnoteTests.swift
//  floatnoteTests
//
//  Created by Michaela Barcia on 3/1/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

@testable import floatnote
import floatnote
import XCTest

class floatnoteTests: XCTestCase {
    

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLogin() {
        let service = MockFloatieService()
        let authState = AuthState(floatieService: service)
        let expectation = XCTestExpectation(description: "login")
        authState.login(usernameOrEmail: "username", password: "password", onSuccess: {}) { _ in
            expectation.fulfill()
        }
        XCTAssertTrue(authState.isLoggedIn)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
