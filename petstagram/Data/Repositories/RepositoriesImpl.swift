//
//  PetstagramRepositoriesImpl.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import FirebaseAuth
import GoogleSignIn

class RepositoriesImpl : Repositories {
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func fetchPosts(completion: @escaping (Result<[PostEntity], Error>) -> Void) {
        
    }
    
    func signIn(email: String, password: String) async throws -> User {
        return try await authService.signIn(email: email, password: password)
    }
    
    func signInWithGoogle() async throws -> User {
        return try await authService.signInWithGoogle()
    }
    
    func signUp(email: String, password: String) async throws -> User {
        return try await authService.signUp(email: email, password: password)
    }
}
