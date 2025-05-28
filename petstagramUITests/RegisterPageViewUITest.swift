//
//  RegisterPageViewUITest.swift
//  petstagram
//
//  Created by Parama Artha on 21/05/25.
//

import XCTest

final class RegisterPageUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("UITests")
        app.launch()
        if app.otherElements["NavigationBar"].exists == false {
            try navigateToRegisterPage()
        }
    }
    
    private func navigateToRegisterPage() throws {
        // Tap on Sign Up link
        app.buttons["Sign Up"].tap()
    }
    
    override func tearDown() {
        // Sign out after each test
        if app.otherElements["NavigationBar"].exists {
            // Navigate to profile page
            app.otherElements["NavigationBar"].buttons["Profile"].tap()
            
            // Scroll to find sign out button if needed
            let signOutButton = app.buttons["Sign Out"]
            if signOutButton.exists {
                signOutButton.tap()
            }
        }
        
        super.tearDown()
    }
    
    func testRegisterPageInitialState() throws {
        // Verify initial UI elements are present
        XCTAssertTrue(app.images["AppLogo"].exists)
        XCTAssertTrue(app.staticTexts["Sign Up"].exists)
        XCTAssertTrue(app.staticTexts["Personalize your pet's page with photos, details and memories."].exists)
        
        // Verify text fields
        let emailTextField = app.textFields["Email"]
        let passwordTextField = app.secureTextFields["Password"]
        let reTypePasswordTextField = app.secureTextFields["Re-Type Password"]
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(passwordTextField.exists)
        XCTAssertTrue(reTypePasswordTextField.exists)
        XCTAssertEqual(emailTextField.placeholderValue, "Email ")
        XCTAssertEqual(passwordTextField.placeholderValue, "Password ")
        XCTAssertEqual(reTypePasswordTextField.placeholderValue, "Re-Type Password ")
        
        // Verify buttons
        let signUpButton = app.buttons["Sign Up"]
        XCTAssertTrue(signUpButton.exists)
        
        // Verify sign up link
        XCTAssertTrue(app.staticTexts["Already has an account?"].exists)
        XCTAssertTrue(app.staticTexts["Sign In"].exists)
    }
    
    func testRegisterWithEmptyFields() throws {
        // Try to login with empty fields
        app.buttons["Sign Up"].tap()
        
        // Verify error message
        let errorMessage = app.staticTexts["Please fill in all fields"]
        XCTAssertTrue(errorMessage.exists)
    }
    
    func testRegisterWithInvalidPasswordFields() throws {
        // Enter email
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("test@example.com")
        
        // Enter password
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("test")
        
        // Re-type password
        let reTypePasswordTextField = app.secureTextFields["Re-Type Password"]
        reTypePasswordTextField.tap()
        reTypePasswordTextField.typeText("test")
        
        app.buttons["Sign Up"].tap()
        
        // Verify error message
        let errorMessage = app.staticTexts["The password must be 6 characters long or more."]
        let appeared = errorMessage.waitForExistence(timeout: 5)
        XCTAssertTrue(appeared)
    }
    
    func testRegisterWithInvalidEmail() throws {
        // Enter invalid email
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("invalid-email")
        
        // Enter password
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("password123")
        
        // Re-type password
        let reTypePasswordTextField = app.secureTextFields["Re-Type Password"]
        reTypePasswordTextField.tap()
        reTypePasswordTextField.typeText("password123")
        
        // Try to login
        app.buttons["Sign Up"].tap()
        
        // Verify error message (assuming Firebase auth error)
        let errorMessage = app.staticTexts["The email address is badly formatted."]
        let appeared = errorMessage.waitForExistence(timeout: 5)
        XCTAssertTrue(appeared)
    }
    
    func testNavigationToSignIn() throws {
        // Tap on Sign Up link
        app.staticTexts["Sign In"].tap()
        
        // Verify navigation to Register page
        XCTAssertTrue(app.staticTexts["Sign In"].exists) // Header text
        XCTAssertTrue(app.staticTexts["Do not has an account?"].exists)
    }
    
    func testTextFieldInteraction() throws {
        // Test email field
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("test@example.com")
        XCTAssertEqual(emailTextField.value as? String, "test@example.com")
        
        // Test password field
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("password123")
        
        // Test re-type password field
        let reTypePasswordTextField = app.secureTextFields["Re-Type Password"]
        reTypePasswordTextField.tap()
        reTypePasswordTextField.typeText("password123")
    }
    
    func testLoadingState() throws {
        // Enter credentials
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("test@example.com")
        
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("password123")
        
        let reTypePasswordTextField = app.secureTextFields["Re-Type Password"]
        reTypePasswordTextField.tap()
        reTypePasswordTextField.typeText("password123")
        
        // Tap sign in button
        app.buttons["Sign Up"].tap()
        
        // Verify loading state
        let loadingButton = app.buttons["Signing up..."]
        XCTAssertTrue(loadingButton.exists)
        XCTAssertTrue(loadingButton.isEnabled == false) // Button should be disabled during loading
    }
}
