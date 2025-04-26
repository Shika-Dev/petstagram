//
//  PetstagramRepositories.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import FirebaseAuth
import GoogleSignIn

protocol Repositories {
    func fetchPosts(completion: @escaping (Result<[PostEntity], Error>) -> Void)
    func signIn(email: String, password: String) async throws -> User
    func signInWithGoogle() async throws -> User
}
