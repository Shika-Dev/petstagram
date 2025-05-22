//
//  EditProfilePageViewModelTest.swift
//  petstagramTests
//
//  Created by Parama Artha on 22/05/25.
//

import XCTest
@testable import petstagram

final class EditProfilePageViewModelTests: XCTestCase {
    var sut: EditProfilePageViewModel!
    var mockUseCase: MockUserUseCases!
    var mockUserDefaultsManager: MockUserDefaultsManager!
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockUseCase = MockUserUseCases()
        mockUserDefaultsManager = MockUserDefaultsManager()
        sut = EditProfilePageViewModel(useCase: mockUseCase, userDefaultsManager: mockUserDefaultsManager)
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        mockUserDefaultsManager = nil
        super.tearDown()
    }
    
    @MainActor
    func testLoadUserProfileSuccess() async {
        // Given
        let mockUser = UserEntity(
            uid: "test123",
            fullName: "Test User",
            userName: "testuser",
            dateOfBirth: Date(),
            bio: "Test bio",
            info: InfoData.empty(),
            lifeEvents: []
        )
        mockUserDefaultsManager.userUID = "test123"
        mockUseCase.mockGetUserResult = mockUser
        
        // When
        await sut.loadUserProfile()
        
        // Then
        XCTAssertEqual(sut.fullName, "Test User")
        XCTAssertEqual(sut.userName, "testuser")
        XCTAssertEqual(sut.bio, "Test bio")
    }
    
    @MainActor
    func testUpdateProfileEmptyFieldsShowsError() {
        // Given
        sut.fullName = ""
        sut.userName = ""
        
        // When
        sut.updateProfile()
        
        // Then
        XCTAssertEqual(sut.error, "Please fill in all required fields")
        XCTAssertFalse(sut.isProfileSaved)
    }
    
    @MainActor
    func testUpdateProfileSuccess() async {
        // Given
        mockUserDefaultsManager.userUID = "test123"
        sut.fullName = "Test User"
        sut.userName = "testuser"
        sut.bio = "Test bio"
        
        // When
        sut.updateProfile()
        
        // Then
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        XCTAssertTrue(sut.isProfileSaved)
        XCTAssertNil(sut.error)
    }
}

