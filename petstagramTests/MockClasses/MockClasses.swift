//
//  MockClasses.swift
//  petstagram
//
//  Created by Parama Artha on 21/05/25.
//

import XCTest
import FirebaseAuth
@testable import petstagram

// MARK: USECASE
class MockAuthUseCases: AuthUseCases {
    var mockSignInResult: AuthUser?
    var mockGoogleSignInResult: AuthUser?
    var mockError: Error?
    
    func signIn(email: String, password: String) async throws -> AuthUser {
        if let error = mockError {
            throw error
        }
        return mockSignInResult!
    }
    
    func signUp(email: String, password: String) async throws -> AuthUser {
        if let error = mockError {
            throw error
        }
        return mockSignInResult!
    }
    
    func signInWithGoogle() async throws -> AuthUser {
        if let error = mockError {
            throw error
        }
        return mockGoogleSignInResult!
    }
}


class MockUserUseCases: UserUseCases {
    var mockGetUserResult: UserEntity?
    var mockError: Error?
    var updateUserCalled = false
    
    func getUser(uid: String) async throws -> UserEntity? {
        if let error = mockError {
            throw error
        }
        return mockGetUserResult
    }
    
    func createOrUpdateUser(user: UserEntity, newImage: UIImage?) async throws {
        if let error = mockError {
            throw error
        }
        updateUserCalled = true
    }
}

class MockPostUseCase: PostUseCases {
    var mockPosts: [PostEntity] = []
    var shouldThrowError = false
    var updateCommentCalled = false
    var updateLikeCalled = false
    
    func fetchPosts() async throws -> [petstagram.PostEntity] {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Fetch Post Test error"])
        }
        return mockPosts
    }
    
    func updateLike(id postId: String, likes list: [String]) async throws {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Update Like Test error"])
        }
        updateLikeCalled = true
    }
    
    func fetchUserPosts() async throws -> [petstagram.PostEntity] {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Fetch User Post Test error"])
        }
        return mockPosts
    }
    
    func updateComments(id postId: String, comments list: [petstagram.CommentEntity]) async throws {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Update Comments Test error"])
        }
        updateCommentCalled = true
    }
    
    func uploadPosts(image: UIImage, caption: String) async throws {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test Upload Post error"])
        }
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
    }
}

// MARK: MANAGERS
class MockAuthStateManager: AuthStateManaging {
    var isAuthenticated: Bool = false
    var currentUser: User?
    var isNewUser: Bool = false
    
    func setNewUserStatus(_ status: Bool) {
        isNewUser = status
    }
    
    func signOut() throws {
        isAuthenticated = false
        currentUser = nil
        isNewUser = false
    }
}

class MockUserDefaultsManager: UserDefaultsManager {
    private var mockUserUID: String?
    private var mockUsername: String?
    private var mockFullName: String?
    private var mockBio: String?
    private var mockProfilePictureUrl: String?
    
    override var userUID: String? {
        get { mockUserUID }
        set { mockUserUID = newValue }
    }
    
    override var username: String? {
        get { mockUsername }
        set { mockUsername = newValue }
    }
    
    override var fullName: String? {
        get { mockFullName }
        set { mockFullName = newValue }
    }
    
    override var bio: String? {
        get { mockBio }
        set { mockBio = newValue }
    }
    
    override var profilePictureUrl: String? {
        get { mockProfilePictureUrl }
        set { mockProfilePictureUrl = newValue }
    }
    
    override func clearUserData() {
        mockUserUID = nil
        mockUsername = nil
        mockFullName = nil
        mockBio = nil
        mockProfilePictureUrl = nil
    }
}

// MARK: MODEL
class MockAuthUser: AuthUser {
    var uid: String
    var email: String?
    var displayName: String?

    init(uid: String, email: String?, displayName: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
    }
}
