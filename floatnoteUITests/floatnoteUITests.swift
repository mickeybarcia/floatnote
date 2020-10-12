//
//  floatnoteUITests.swift
//  floatnoteUITests
//
//  Created by Michaela Barcia on 3/1/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import XCTest

class floatnoteUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSignup() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // can sign up
        app.buttons["SIGNUP"].tap()
        app.textFields["username *"].tap()
        app.textFields["username *"].typeText("uiTest4")
        app.textFields["email *"].tap()
        app.textFields["email *"].typeText("uitest@gmail.com")
        app.textFields["age *"].doubleTap()
        app.textFields["age *"].typeText("10")
        app.secureTextFields["password *"].tap()
        app.secureTextFields["password *"].typeText("uitest")
        app.secureTextFields["confirm password *"].tap()
        app.secureTextFields["confirm password *"].typeText("uitest")
        app.textFields["gender"].tap()
        app.textFields["gender"].typeText("uitest")
        app.buttons["SIGNUP"].doubleTap()
        
        let button = app.buttons["GOT IT"]
                XCTAssertTrue(button.waitForExistence(timeout: 10))
        button.tap()
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
