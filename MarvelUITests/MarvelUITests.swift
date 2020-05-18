//
//  MarvelUITests.swift
//  MarvelUITests
//
//  Created by MarvelDev on 14/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import XCTest

class MarvelUITests: XCTestCase {
    
    private let app = XCUIApplication()
    private let notExistsPredicate = NSPredicate(format: "exists != 1")
    private let kTimeOut = 30.0
    
    func testMarvel() throws {
        app.launch()
        detectedHUD()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.tap()
        detectedHUD()
        let tablesQuery = app.tables
        let button = tablesQuery.otherElements["Comics"].children(matching: .button).element
        button.tap()
        button.tap()
        
        let button2 = tablesQuery.otherElements["Stories"].children(matching: .button).element
        button2.tap()
        button2.tap()
        
        let button3 = tablesQuery.otherElements["Events"].children(matching: .button).element
        button3.tap()
        button3.tap()
        tablesQuery.otherElements["Links"].children(matching: .button).element.tap()
        app.navigationBars["Marvel.CharacterDetailView"].buttons["arrowleft"].tap()
    }

    func testLaunchPerformance() throws {
        if #available(iOS 13.0, *) {
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

//MARK: - private methods -
extension MarvelUITests {
    private func detectedHUD() {
        expectation(for: notExistsPredicate, evaluatedWith: app.otherElements["HUD"], handler: nil)
        waitForExpectations(timeout: kTimeOut, handler: nil)
    }
}
