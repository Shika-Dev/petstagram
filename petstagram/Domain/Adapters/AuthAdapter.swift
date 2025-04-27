//
//  AuthAdapter.swift
//  petstagram
//
//  Created by Parama Artha on 26/04/25.
//

import FirebaseAuth
import GoogleSignIn

final class AuthUseCaseAdapter: AuthUseCases {
    private let repository: Repositories
    
    init(repository: Repositories) {
        self.repository = repository
    }
    
    func signIn(email: String, password: String) async throws -> User {
        return try await repository.signIn(email: email, password: password)
    }
    
    func signInWithGoogle() async throws -> User {
        return try await repository.signInWithGoogle()
    }
    
    func signUp(email: String, password: String) async throws -> User {
        return try await repository.signUp(email: email, password: password)
    }
} 
