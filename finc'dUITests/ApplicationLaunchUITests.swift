//
//  ApplicationLaunchUITests.swift
//  finc'dUITests
//

import XCTest

@MainActor
final class ApplicationLaunchUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testApplicationLaunchesToHome() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["finc'd"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Continue"].exists)
    }
}
