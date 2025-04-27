//
//  ContentViewModel.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import Foundation

@MainActor
final class ContentViewModel: ObservableObject {
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
