import XCTest

final class HomePageUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["UI-Testing"]
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
    
    func testInitialState() {
        // Verify home page elements exist
        let navBar = app.otherElements["NavigationBar"]
        XCTAssertTrue(navBar.exists)
        XCTAssertTrue(app.images["AppLogo"].exists)
        XCTAssertTrue(app.staticTexts["Petstagram"].exists)
        
        // Verify scroll view exists
        XCTAssertTrue(app.scrollViews.firstMatch.exists)
    }
    
    func testPostInteraction() {
        // Wait for posts to load
        let postElement = app.otherElements["PostElement"].firstMatch
        let postExists = postElement.waitForExistence(timeout: 5)
        XCTAssertTrue(postExists, "Post should be visible")
        
        // Test like button
        let likeButton = postElement.images["LikeButton"]
        likeButton.tap()
        
        // Verify like count updates
        let likeCount = postElement.staticTexts["LikeCount"]
        XCTAssertTrue(likeCount.exists)
        
        // Test comment button
        let commentButton = postElement.images["CommentButton"]
        commentButton.tap()
        
        // Verify comment sheet appears
        XCTAssertTrue(app.navigationBars["Comments"].exists)
    }
    
    func testCommentSheet() {
        // Open comment sheet for first post
        let postElement = app.otherElements["PostElement"].firstMatch
        postElement.images["CommentButton"].tap()
        
        // Verify comment sheet elements
        XCTAssertTrue(app.navigationBars["Comments"].exists)
        XCTAssertTrue(app.textFields["Add a comment..."].exists)
        XCTAssertTrue(app.buttons["SendCommentButton"].exists)
        
        // Test adding a comment
        let commentField = app.textFields["Add a comment..."]
        commentField.tap()
        commentField.typeText("Test comment via UI test")
        
        // Send comment
        app.buttons["SendCommentButton"].tap()
        
        // Verify comment was added
        let commentText = app.staticTexts["Test comment via UI test"]
        let commentExists = commentText.waitForExistence(timeout: 2)
        XCTAssertTrue(commentExists, "Comment should be visible")
    }
    
    func testPullToRefresh() {
        // Perform pull to refresh
        let homeView = app.scrollViews.firstMatch
        let start = homeView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.8))
        let end = homeView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
        start.press(forDuration: 0.1, thenDragTo: end)
        
        // Wait for refresh to complete
        Thread.sleep(forTimeInterval: 1)
        
        // Verify home page is still visible
        XCTAssertTrue(app.otherElements["NavigationBar"].exists)
    }
} 
