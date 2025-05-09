//
//  AuthStateManager.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import Foundation
import FirebaseAuth

@MainActor
final class AuthStateManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?
    @Published var isNewUser: Bool = false
    
    init() {
        setupAuthStateListener()
    }
    
    private func setupAuthStateListener() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isAuthenticated = user != nil
            self?.currentUser = user
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        isAuthenticated = false
        currentUser = nil
        isNewUser = false
        UserDefaultsManager.shared.clearUserData()
    }
    
    func setNewUserStatus(_ isNew: Bool) {
        isNewUser = isNew
    }
}
