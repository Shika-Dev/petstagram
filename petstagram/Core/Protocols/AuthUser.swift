//
//  AuthUser.swift
//  petstagram
//
//  Created by Parama Artha on 20/05/25.
//

import FirebaseAuth

protocol AuthUser {
    var uid: String { get }
    var email: String? { get }
    var displayName: String? { get }
}

extension User: AuthUser {}
