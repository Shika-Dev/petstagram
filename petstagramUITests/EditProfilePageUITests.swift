//
//  EditProfilePageUITest.swift
//  petstagramTests
//
//  Created by Parama Artha on 22/05/25.
//

import XCTest

final class EditProfilePageUITests: XCTestCase {
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
            app.buttons["EditProfileButton"].tap()
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
    
    func testEditProfilePageElementsExist() {
        // Verify all main elements are present
        XCTAssertTrue(app.otherElements["EditProfilePage"].exists)
        
        // Check text fields
        let fullNameField = app.textFields["Full name"]
        let userNameField = app.textFields["User name"]
        let bioField = app.textViews["Bio"]
        
        XCTAssertTrue(fullNameField.exists)
        XCTAssertTrue(userNameField.exists)
        XCTAssertTrue(bioField.exists)
        
        // Check continue button
        let continueButton = app.buttons["Continue"]
        XCTAssertTrue(continueButton.exists)
    }
    
    func testEditProfileValidation() {
        // Try to submit empty form
        let continueButton = app.buttons["Continue"]
        continueButton.tap()
        
        // Verify error message appears
        let errorMessage = app.staticTexts["Please fill in all required fields"]
        XCTAssertTrue(errorMessage.exists)
        
        // Fill in required fields
        let fullNameField = app.textFields["Full name"]
        let userNameField = app.textFields["User name"]
        
        fullNameField.tap()
        fullNameField.typeText("Test User")
        
        userNameField.tap()
        userNameField.typeText("testuser")
        
        // Try submitting again
        continueButton.tap()
        
        // Verify error message is gone
        XCTAssertFalse(errorMessage.exists)
    }
    
    func testProfileImageInteraction() {
        // Tap on profile image
        let profileImage = app.otherElements["ProfileImage"]
        XCTAssertTrue(profileImage.exists)
        profileImage.tap()
        
        // Verify image picker appears
        let imagePicker = app.otherElements["ImagePicker"]
        XCTAssertTrue(imagePicker.waitForExistence(timeout: 3))
    }
    
    func testDatePickerInteraction() {
        // Tap on date field
        let dateField = app.datePickers["DatePicker"]
        XCTAssertTrue(dateField.exists)
        dateField.tap()
        
        // Verify date picker appears
        let datePicker = app.datePickers.firstMatch
        XCTAssertTrue(datePicker.exists)
    }
} 
