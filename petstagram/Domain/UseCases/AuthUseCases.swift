//
//  AuthUseCases.swift
//  petstagram
//
//  Created by Parama Artha on 26/04/25.
//

import GoogleSignIn

protocol AuthUseCases {
    func signIn(email: String, password: String) async throws -> AuthUser
    func signInWithGoogle() async throws -> AuthUser
    func signUp(email: String, password: String) async throws -> AuthUser
}
