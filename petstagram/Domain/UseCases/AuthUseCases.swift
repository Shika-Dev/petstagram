//
//  AuthUseCases.swift
//  petstagram
//
//  Created by Parama Artha on 26/04/25.
//

import FirebaseAuth
import GoogleSignIn

protocol AuthUseCases {
    func signIn(email: String, password: String) async throws -> User
    func signInWithGoogle() async throws -> User
    func signUp(email: String, password: String) async throws -> User
}
