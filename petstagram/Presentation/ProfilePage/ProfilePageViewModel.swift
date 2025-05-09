//
//  ProfilePageViewModel.swift
//  petstagram
//
//  Created by Parama Artha on 08/05/25.
//

import Foundation

@MainActor
final class ProfilePageViewModel: ObservableObject {
    private let authStateManager: AuthStateManager
    
    init(authStateManager: AuthStateManager) {
        self.authStateManager = authStateManager
    }
    
    func signOut() {
        do {
            try authStateManager.signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
