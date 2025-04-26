//
//  PetstagramRepositoriesImpl.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import FirebaseAuth

class RepositoriesImpl : Repositories {
    func fetchPosts(completion: @escaping (Result<[PostEntity], Error>) -> Void) {
        
    }
    
    func signIn(email: String, password: String) async throws -> User {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return result.user
        } catch {
            throw error
        }
    }
}
