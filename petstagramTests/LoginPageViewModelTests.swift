import XCTest
import FirebaseAuth
@testable import petstagram

final class LoginPageViewModelTests: XCTestCase {
    var sut: LoginPageViewModel!
    var mockAuthUseCase: MockAuthUseCases!
    var mockUserUseCase: MockUserUseCases!
    var mockAuthStateManager: MockAuthStateManager!
    var mockUserDefaultsManager: MockUserDefaultsManager!
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockAuthUseCase = MockAuthUseCases()
        mockUserUseCase = MockUserUseCases()
        mockAuthStateManager = MockAuthStateManager()
        mockUserDefaultsManager = MockUserDefaultsManager()
        
        sut = LoginPageViewModel(
            useCase: mockAuthUseCase,
            authStateManager: mockAuthStateManager,
            userUseCase: mockUserUseCase,
            userDefaultsManager: mockUserDefaultsManager
        )
    }
    
    @MainActor
    override func tearDown() {
        sut = nil
        mockAuthUseCase = nil
        mockUserUseCase = nil
        mockAuthStateManager = nil
        mockUserDefaultsManager = nil
        super.tearDown()
    }
    
    @MainActor
    func testLoginWithEmptyFields() async {
        // Given
        sut.email = ""
        sut.password = ""
        
        // When
        await sut.login()
        
        // Then
        XCTAssertEqual(sut.error, "Please fill in all fields")
        XCTAssertFalse(sut.isLoading)
    }
    
    @MainActor
    func testLoginSuccess() async {
        // Given
        sut.email = "test@example.com"
        sut.password = "password123"
        let mockUser = MockAuthUser(uid: "test123", email: "google@example.com", displayName: "test")
        
        mockAuthUseCase.mockSignInResult = mockUser
        
        // When
        await sut.login()
        
        // Then
        XCTAssertNil(sut.error)
        XCTAssertFalse(mockAuthStateManager.isNewUser)
        XCTAssertFalse(sut.isLoading)
        
    }
    
    @MainActor
    func testLoginFailure() async {
        // Given
        sut.email = "test@example.com"
        sut.password = "wrongpassword"
        mockAuthUseCase.mockError = NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])
        
        // When
        await sut.login()
        
        // Then
        XCTAssertEqual(sut.error, "Invalid credentials")
        XCTAssertFalse(sut.isLoading)
    }
    
    @MainActor
    func testGoogleSignInSuccess() async {
        // Given
        let mockUser = MockAuthUser(uid: "google123", email: "google@example.com", displayName: "Google User")
        let mockUserData = UserEntity(
            uid: "google123",
            fullName: "Google User",
            userName: "googleuser",
            dateOfBirth: Date(),
            bio: "Google bio",
            info: InfoData.empty(),
            lifeEvents: []
        )
        
        mockAuthUseCase.mockGoogleSignInResult = mockUser
        mockUserUseCase.mockGetUserResult = mockUserData
        
        // When
        await sut.signInWithGoogle()
        
        // Then
        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(mockAuthStateManager.isNewUser)
    }
    
    @MainActor
    func testGoogleSignInFailure() async {
        // Given
        mockAuthUseCase.mockError = NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Google sign in failed"])
        
        // When
        await sut.signInWithGoogle()
        
        // Then
        XCTAssertEqual(sut.error, "Google sign in failed")
        XCTAssertFalse(sut.isLoading)
    }
}


