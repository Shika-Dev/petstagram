//
//  ContentViewUITest.swift
//  petstagramUITests
//
//  Created by Parama Artha on 21/05/25.
//

import XCTest

final class ContentViewUITest: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        
        // Login if not already authenticated
        if app.otherElements["NavigationBar"].exists == false {
            try login()
        }
    }
    
    private func login() throws {
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("test@icloud.com")
        
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("test123")
        
        // Tap sign in button
        app.buttons["Sign In"].tap()
        
        // Wait for navigation to complete
        let contentView = app.otherElements["NavigationBar"]
        let appeared = contentView.waitForExistence(timeout: 5)
        XCTAssertTrue(appeared, "Should navigate to Content view after successful login")
    }
    
    func testContentPageInitialState() throws {
        // Verify initial UI elements are present
        let navBar = app.otherElements["NavigationBar"]
        let homeButton = navBar.buttons["Home"]
        let addButton = navBar.buttons["AddPost"]
        let profileButton = navBar.buttons["Profile"]
        
        XCTAssertTrue(navBar.exists)
        XCTAssertTrue(homeButton.exists)
        XCTAssertTrue(addButton.exists)
        XCTAssertTrue(profileButton.exists)
        
        //Verify icon and TabView change
        homeButton.tap()
        
        XCTAssertTrue(homeButton.images["PawFilled"].exists)
        XCTAssertTrue(addButton.images["plus.app"].exists)
        XCTAssertTrue(profileButton.images["Person"].exists)
        XCTAssertTrue(app.staticTexts["Petstagram"].exists)
        
        addButton.tap()
        
        XCTAssertTrue(homeButton.images["Paw"].exists)
        XCTAssertTrue(addButton.images["plus.app.fill"].exists)
        XCTAssertTrue(profileButton.images["Person"].exists)
        XCTAssertTrue(app.staticTexts["New post"].exists)
        
        profileButton.tap()
        
        XCTAssertTrue(homeButton.images["Paw"].exists)
        XCTAssertTrue(addButton.images["plus.app"].exists)
        XCTAssertTrue(profileButton.images["PersonFilled"].exists)
        XCTAssertTrue(app.buttons["Sign Out"].exists)
    }
}
