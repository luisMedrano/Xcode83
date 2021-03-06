//
//  xcode832UITests.swift
//  xcode832UITests
//
//  Created by mvemjsun on 26/05/2017.
//  Copyright © 2017 . All rights reserved.
//

import XCTest

class xcode832UITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // Siri and Activities
    func testLaunchAndSendToBG()  {
        let element1 = XCUIApplication().staticTexts["Country Name from ISO3 code"]
        let element2 = XCUIApplication().textFields["Enter 3 letter Country Code"]
        
        Given("I wait for the screen header to Appear") { _ in
            let result1 = waitForElementToExist(element: element1)
            XCTAssertTrue(result1)
        }
        
        When("I press the home button") { _ in
            XCUIDevice.shared().press(XCUIDeviceButton.home)
        }
        
        And("I ask Siri to open my App") { _ in
            XCUIDevice.shared().siriService.activate(voiceRecognitionText: "open xcode832")
        }
        
       Then("I should see the text Enter 3 letter Country Code") { _ in
            let result2 = waitForElementToExist(element: element2)
            XCTAssertTrue(result2)
        }
    }
    
    // Screen shots
    func testGetAValidCountryCode() {
        let countryCodeTextInputElement = XCUIApplication().textFields.matching(identifier: "countryCodeField").element(boundBy: 0)
        let countryDescription = XCUIApplication().textFields["Australia"]
        let getInfoButton = XCUIApplication().buttons.matching(identifier: "getCountryInfo").element(boundBy: 0)
        let readyToInput = XCUIApplication().staticTexts["Enter 3 letter Country Code"]
        
        _ = waitForElementToExist(element: readyToInput)
        countryCodeTextInputElement.tap()
        countryCodeTextInputElement.typeText("AUS")
        getInfoButton.tap()
        XCTAssertTrue(waitForElementToExist(element: countryDescription))
        
        // Capture Screenshot
        XCTContext.runActivity(named: "Capture screenshot") { activity in
        let screen = XCUIScreen.main
        let screenShot = screen.screenshot()
        let attachment = XCTAttachment(screenshot: screenShot)
        attachment.lifetime = .keepAlways // Keep even if test fails, else xcode deletes it.
        activity.add(attachment)
        }
    }
    
    func testGetAnInvalidCountryCode() {
        let countryCodeTextInputElement = XCUIApplication().textFields.matching(identifier: "countryCodeField").element(boundBy: 0)
        let readyToInput = XCUIApplication().staticTexts["Enter 3 letter Country Code"]
        let getInfoButton = XCUIApplication().buttons.matching(identifier: "getCountryInfo").element(boundBy: 0)
        
        _ = waitForElementToExist(element: readyToInput)
        countryCodeTextInputElement.tap()
        countryCodeTextInputElement.typeText("XXX")
        getInfoButton.tap()
    }
    
    // Waiting for expectations
    func waitForElementToExist(element e: XCUIElement) -> Bool {
        let p = NSPredicate(format: "exists == true")
        let e1 = XCTNSPredicateExpectation(predicate: p, object: e)
        let result = XCTWaiter.wait(for: [e1], timeout: 10)
        return (result == .completed)
    }
}
