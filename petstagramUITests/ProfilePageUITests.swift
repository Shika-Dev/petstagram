//
//  ProfilePageUITest.swift
//  petstagramTests
//
//  Created by Parama Artha on 27/05/25.
//

import XCTest

final class ProfilePageUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["UI-Testing"]
        app.launch()
        
        let navBar = app.otherElements["NavigationBar"]
        let profileButton = navBar.buttons["Profile"]
        // Login if not already authenticated
        if navBar.exists == false {
            try login()
        } else {
            //Navigate to Edit Profile
            profileButton.tap()
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
    
    func testInitialState() {
        // Verify profile elements exist
        XCTAssertTrue(app.buttons["Edit Profile"].exists)
        XCTAssertTrue(app.buttons["Sign Out"].exists)
        
        // Verify tab bar exists
        XCTAssertTrue(app.buttons["Info"].exists)
        XCTAssertTrue(app.buttons["Posts"].exists)
    }
    
    func testEditProfileNavigation() {
        // Tap edit profile button
        app.buttons["Edit Profile"].tap()
        
        // Verify navigation to edit profile page
        XCTAssertTrue(app.textFields["Full name"].exists)
    }
    
    func testEditInfoSheet() {
        // Tap edit button in Info tab
        app.buttons["EditInformationButton"].tap()
        
        // Verify edit info sheet is presented
        XCTAssertTrue(app.navigationBars["Edit Information"].exists)
        
        // Test form fields
        let nameField = app.textFields["Name"]
        nameField.tap()
        nameField.typeText("Updated Pet Name")
        
        // Save changes
        app.buttons["Save"].tap()
        
        // Verify sheet is dismissed
        XCTAssertFalse(app.navigationBars["Edit Information"].exists)
    }
    
    func testEditLifeEventsSheet() {
        // Switch to Info tab if not already there
        if !app.buttons["PawFilled"].exists {
            app.buttons["Paw"].tap()
        }
        
        // Tap edit button for life events
        app.buttons["EditLifeEventButton"].tap()
        
        // Verify edit life events sheet is presented
        XCTAssertTrue(app.otherElements["EditLifeEventSheet"].exists)
        
        // Add new life event
        app.buttons["AddLifeEventButton"].tap()
        
        // Fill in the new event
        let yearField = app.textFields["Year"].firstMatch
        yearField.tap()
        yearField.typeText("2023")
        
        let eventField = app.textViews["Events"].firstMatch
        eventField.tap()
        eventField.typeText("New milestone")
        
        // Save changes
        app.buttons["Save"].tap()
        
        // Verify sheet is dismissed
        XCTAssertFalse(app.otherElements["EditLifeEventSheet"].exists)
    }
    
    func testSwitchTabs() {
        // Switch to Posts tab
        app.buttons["Image"].tap()
        
        // Verify posts grid is shown
        XCTAssertTrue(app.buttons["ImageFilled"].exists)
        XCTAssertTrue(app.otherElements["PostTab"].exists)
        
        // Switch back to Info tab
        app.buttons["Info"].tap()
        
        // Verify info content is shown
        XCTAssertTrue(app.buttons["PawFilled"].exists)
        XCTAssertTrue(app.staticTexts["Information"].exists)
    }
    
    func testSignOut() {
        // Tap sign out button
        app.buttons["Sign Out"].tap()
        
        // Verify navigation to login screen
        let loginButton = app.buttons["Sign In"]
        let appeared = loginButton.waitForExistence(timeout: 5)
        XCTAssertTrue(appeared, "Should navigate to login screen after signing out")
    }
    
    func testPullToRefresh() {
        // Perform pull to refresh
        let profileView = app.scrollViews.firstMatch
        let start = profileView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.8))
        let end = profileView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
        start.press(forDuration: 0.1, thenDragTo: end)
        
        // Wait for refresh to complete
        Thread.sleep(forTimeInterval: 1)
        
        // Verify profile is still visible
        XCTAssertTrue(app.otherElements["NavigationBar"].exists)
    }
} 
