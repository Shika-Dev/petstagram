import XCTest

final class LoginPageUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
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
    
    func testLoginPageInitialState() throws {
        // Verify initial UI elements are present
        XCTAssertTrue(app.images["AppLogo"].exists)
        XCTAssertTrue(app.staticTexts["Sign In"].exists)
        XCTAssertTrue(app.staticTexts["Personalize your pet's page with photos, details and memories."].exists)
        
        // Verify text fields
        let emailTextField = app.textFields["Email"]
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(passwordTextField.exists)
        XCTAssertEqual(emailTextField.placeholderValue, "Email ")
        XCTAssertEqual(passwordTextField.placeholderValue, "Password ")
        
        XCTAssertTrue(app.otherElements["Divider"].exists)
        
        // Verify buttons
        let signInButton = app.buttons["Sign In"]
        let googleButton = app.otherElements["Google SignIn Button"]
        XCTAssertTrue(signInButton.exists)
        XCTAssertTrue(googleButton.exists)
        
        // Verify sign up link
        XCTAssertTrue(app.staticTexts["Do not has an account?"].exists)
        XCTAssertTrue(app.buttons["Sign Up"].exists)
    }
    
    func testLoginWithEmptyFields() throws {
        // Try to login with empty fields
        app.buttons["Sign In"].tap()
        
        // Verify error message
        let errorMessage = app.staticTexts["Please fill in all fields"]
        XCTAssertTrue(errorMessage.exists)
    }
    
    func testLoginWithInvalidEmail() throws {
        // Enter invalid email
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("invalid-email")
        
        // Enter password
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("password123")
        
        // Try to login
        app.buttons["Sign In"].tap()
        
        // Verify error message (assuming Firebase auth error)
        let errorMessage = app.staticTexts["The email address is badly formatted."]
        let appeared = errorMessage.waitForExistence(timeout: 5)
        XCTAssertTrue(appeared)
    }
    
    func testLoginWithInvalidCredentials() throws {
        // Enter valid email format but non-existent account
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("nonexistent@example.com")
        
        // Enter password
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("wrongpassword")
        
        // Try to login
        app.buttons["Sign In"].tap()
        
        // Verify error message (assuming Firebase auth error)
        let errorMessage = app.staticTexts["The supplied auth credential is malformed or has expired."]
        let appeared = errorMessage.waitForExistence(timeout: 5)

        XCTAssertTrue(appeared, "Expected error message did not appear.")
    }
    
    func testNavigationToSignUp() throws {
        // Tap on Sign Up link
        app.buttons["Sign Up"].tap()
        
        // Verify navigation to Register page
        XCTAssertTrue(app.staticTexts["Sign Up"].exists) // Header text
        XCTAssertTrue(app.staticTexts["Already has an account?"].exists)
    }
    
    func testGoogleSignInButton() throws {
        // Verify Google sign in button exists and is tappable
        let googleButton = app.otherElements["Google SignIn Button"]
        XCTAssertTrue(googleButton.exists)
        XCTAssertTrue(googleButton.isHittable)
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
        // Note: We can't verify the password value for security reasons
    }
    
    func testLoadingState() throws {
        // Enter credentials
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("test@example.com")
        
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("password123")
        
        // Tap sign in button
        app.buttons["Sign In"].tap()
        
        // Verify loading state
        let loadingButton = app.buttons["Signing in..."]
        XCTAssertTrue(loadingButton.exists)
        XCTAssertTrue(loadingButton.isEnabled == false) // Button should be disabled during loading
    }
    
    func testPasswordVisibilityToggle() throws {
        // Get password field and visibility toggle button
        let passwordTextField = app.secureTextFields["Password"]
        
        // Enter some password text
        passwordTextField.tap()
        passwordTextField.typeText("testpassword")
        
        // Find and tap the visibility toggle button (it's an Image with SF Symbol)
        let visibilityButton = app.buttons["eye.fill"]
        XCTAssertTrue(visibilityButton.exists)
        visibilityButton.tap()
        
        // Verify password is now visible (secure text field should be replaced with regular text field)
        let visiblePasswordField = app.textFields["Password"]
        XCTAssertTrue(visiblePasswordField.exists)
        XCTAssertEqual(visiblePasswordField.value as? String, "testpassword")
        
        // Toggle visibility back to secure
        let hidePasswordButton = app.buttons["eye.slash.fill"]
        XCTAssertTrue(hidePasswordButton.exists)
        hidePasswordButton.tap()
        
        // Verify password is hidden again
        XCTAssertTrue(passwordTextField.exists)
    }
    
    func testLoginSuccess() throws {
        // Enter valid credentials
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
} 
