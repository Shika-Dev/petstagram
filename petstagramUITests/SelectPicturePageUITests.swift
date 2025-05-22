import XCTest

final class SelectPicturePageUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        
        let navBar = app.otherElements["NavigationBar"]
        let addPostButton = navBar.buttons["AddPost"]
        // Login if not already authenticated
        if navBar.exists == false {
            try login()
        } else {
            //Navigate to Select Picture Page
            addPostButton.tap()
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
        // Verify initial UI elements
        XCTAssertTrue(app.staticTexts["New post"].exists)
        XCTAssertTrue(app.buttons["Next"].exists)
        XCTAssertTrue(app.textViews["Add your Caption"].exists)
        
        // Verify placeholder image is shown
        let placeholderImage = app.otherElements["ImagePlaceholder"]
        XCTAssertTrue(placeholderImage.exists)
    }
    
    func testCaptionInput() {
        let captionTextField = app.textViews["Add your Caption"]
        
        // Test caption input
        captionTextField.tap()
        captionTextField.typeText("Test caption")
        
        // Verify caption was entered
        XCTAssertEqual(captionTextField.value as? String, "Test caption")
    }
    
    func testUploadPostWithoutImage() {
        // Enter caption
        let captionTextField = app.textViews["Add your Caption"]
        captionTextField.tap()
        captionTextField.typeText("Test caption")
        
        // Try to upload without image
        app.buttons["Next"].tap()
        
        // Verify error message
        let errorMessage = app.staticTexts["Please fill in all required fields"]
        XCTAssertTrue(errorMessage.exists)
    }
    
    func testImagePickerPresentation() {
        // Tap on the image area to present picker
        app.otherElements["ImagePlaceholder"].tap()
        
        // Verify image picker is presented
        XCTAssertTrue(app.otherElements["ImagePicker"].exists)
    }
    
    func testLoadingState() {
        // This test might need to be adjusted based on your actual implementation
        // as we can't easily simulate image selection in UI tests
        
        // Enter caption
        let captionTextField = app.textViews["Add your Caption"]
        captionTextField.tap()
        captionTextField.typeText("Test caption")
        
        // Verify loading indicator appears when uploading
        app.buttons["Next"].tap()
        
        // Note: Loading state might be hard to test in UI tests
        // as it depends on actual network calls
        // You might want to mock this in a separate test environment
    }
} 
