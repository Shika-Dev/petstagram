//
//  RegisterPageViewModelTest.swift
//  petstagramTests
//
//  Created by Parama Artha on 21/05/25.
//

import XCTest
import FirebaseAuth
@testable import petstagram

final class RegisterPageViewModelTests: XCTestCase {
    var sut: RegisterPageViewModel!
    var mockAuthUseCase: MockAuthUseCases!
    var mockAuthStateManager: MockAuthStateManager!
    var mockUserDefaultsManager: MockUserDefaultsManager!
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockAuthUseCase = MockAuthUseCases()
        mockAuthStateManager = MockAuthStateManager()
        mockUserDefaultsManager = MockUserDefaultsManager()
        
        sut = RegisterPageViewModel(
            useCase: mockAuthUseCase,
            authStateManager: mockAuthStateManager,
            userDefaultsManager: mockUserDefaultsManager
        )
    }
    
    @MainActor
    override func tearDown() {
        sut = nil
        mockAuthUseCase = nil
        mockAuthStateManager = nil
        mockUserDefaultsManager = nil
        super.tearDown()
    }
    
    @MainActor
    func testRegisterWithEmptyFields() async {
        // Given
        sut.email = ""
        sut.password = ""
        sut.reTypePassword = ""
        
        // When
        await sut.register()
        
        // Then
        XCTAssertEqual(sut.error, "Please fill in all fields")
    }
    
    @MainActor
    func testRegisterWithUnmatchPassword() async {
        // Given
        sut.email = "test@example.com"
        sut.password = "test"
        sut.reTypePassword = "test1"
        
        // When
        await sut.register()
        
        // Then
        XCTAssertEqual(sut.error, "Password does not match")
    }
    
    @MainActor
    func testRegisterSuccess() async {
        // Given
        sut.email = "test@example.com"
        sut.password = "password123"
        sut.reTypePassword = "password123"
        let mockUser = MockAuthUser(uid: "test123", email: "google@example.com", displayName: "test")
        
        mockAuthUseCase.mockSignInResult = mockUser
        
        // When
        await sut.register()
        
        // Then
        XCTAssertNil(sut.error)
        XCTAssertTrue(mockAuthStateManager.isNewUser)
        XCTAssertFalse(sut.isLoading)
        
    }
    
    @MainActor
    func testRegisterDuplicateAccount() async {
        // Given
        sut.email = "test@example.com"
        sut.password = "password123"
        sut.reTypePassword = "password123"
        mockAuthUseCase.mockError = NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "The email address is already in use by another account."])
        
        // When
        await sut.register()
        
        // Then
        XCTAssertEqual(sut.error, "The email address is already in use by another account.")
        
    }

    
}
