//
//  AuthUseCases.swift
//  petstagram
//
//  Created by Parama Artha on 26/04/25.
//

import FirebaseAuth

protocol AuthUseCases {
    func signIn(email: String, password: String) async throws -> User
}
