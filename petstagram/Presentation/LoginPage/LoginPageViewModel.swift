//
//  LoginPageViewModel.swift
//  petstagram
//
//  Created by Parama Artha on 26/04/25.
//

import Foundation

@MainActor
final class LoginPageViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    private let useCase: AuthUseCases
    private let authStateManager: AuthStateManager
    
    init(useCase: AuthUseCases, authStateManager: AuthStateManager) {
        self.useCase = useCase
        self.authStateManager = authStateManager
    }
    
    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            error = "Please fill in all fields"
            return
        }
        
        isLoading = true
        error = nil
        
        Task {
            do {
                let user = try await useCase.signIn(email: email.lowercased(), password: password)
                print("Successfully signed in user: \(user.uid)")
            } catch {
                self.error = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    func signInWithGoogle() {
        isLoading = true
        error = nil
        
        Task {
            do {
                let user = try await useCase.signInWithGoogle()
                print("Successfully signed in with Google: \(user.uid)")
            } catch {
                self.error = error.localizedDescription
            }
            isLoading = false
        }
    }
}
