//
//  WishDishUITests.swift
//  WishDishUITests
//
//  Created by Roshan Sah on 08/10/25.
//

import XCTest

final class WishDishUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    @MainActor
    func testMoodSelection() throws {
        let app = XCUIApplication()
        app.activate()
        
        let element = app.buttons["Drink and Dine mood"].firstMatch
        element.tap()
        let element2 = app.buttons["BackButton"].firstMatch
        element2.tap()
        element.tap()
        element2.tap()
        app.buttons["Premium Dining mood"].firstMatch.tap()
        element2.tap()
        app.buttons["Romantic Dining mood"].firstMatch.tap()
        element2.tap()
        app.buttons["Light & Healthy mood"].firstMatch.tap()
        element2.tap()
        app.buttons["Quick Bite mood"].firstMatch.tap()
        element2.tap()
        app.buttons["Vegetarian Delight mood"].firstMatch.tap()
        element2.tap()
        app.buttons["Spicy Adventure mood"].firstMatch.tap()
        element2.tap()
    }
    
    @MainActor
    func testMoodSelectionToOrder() throws {
        let app = XCUIApplication()
        app.activate()
        app.buttons["Romantic Dining mood"].firstMatch.tap()
        app.buttons.matching(identifier: "Increment").element(boundBy: 0).tap()
        app/*@START_MENU_TOKEN@*/.buttons["Quantity: 1, Added, Increment"]/*[[".steppers.buttons[\"Quantity: 1, Added, Increment\"]",".steppers[\"Quantity: 1, Added\"].buttons[\"Increment\"]",".buttons[\"Quantity: 1, Added, Increment\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["plus.circle.fill"]/*[[".otherElements",".buttons[\"Add\"]",".buttons[\"plus.circle.fill\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Confirm Order"]/*[[".otherElements.buttons[\"Confirm Order\"]",".buttons[\"Confirm Order\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
    }
    
    @MainActor
    func testMenuSelectionToOrder() throws {
        let app = XCUIApplication()
        app.activate()
        app/*@START_MENU_TOKEN@*/.images["menucard.fill"]/*[[".buttons[\"Menu\"].images",".buttons.images[\"menucard.fill\"]",".images[\"menucard.fill\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app.buttons.matching(identifier: "Increment").element(boundBy: 0).tap()
        app/*@START_MENU_TOKEN@*/.buttons["plus.circle.fill"]/*[[".otherElements",".buttons[\"Add\"]",".buttons[\"plus.circle.fill\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.doubleTap()
        app.windows/*@START_MENU_TOKEN@*/.firstMatch/*[[".containing(.other, identifier: nil).firstMatch",".firstMatch"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Confirm Order"]/*[[".otherElements.buttons[\"Confirm Order\"]",".buttons[\"Confirm Order\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
    }
    
    @MainActor
    func testEmptyAddInvoiceAndNavigation() {
        let app = XCUIApplication()
        app.activate()
        let element = app/*@START_MENU_TOKEN@*/.images["plus.circle.fill"]/*[[".buttons[\"Add Invoice\"].images",".buttons",".images[\"add\"]",".images[\"plus.circle.fill\"]"],[[[-1,3],[-1,2],[-1,1,1],[-1,0]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        element.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Go to Menu"]/*[[".otherElements.buttons[\"Go to Menu\"]",".buttons[\"Go to Menu\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        element.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Explore Moods"]/*[[".otherElements.buttons[\"Explore Moods\"]",".buttons[\"Explore Moods\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        element.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Check Previous Invoices"]/*[[".otherElements.buttons[\"Check Previous Invoices\"]",".buttons[\"Check Previous Invoices\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        element.tap()
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
