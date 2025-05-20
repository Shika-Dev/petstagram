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
    private let userUseCase: UserUseCases
    private let authStateManager: AuthStateManaging
    private let userDefaultsManager: UserDefaultsManager
    
    init(useCase: AuthUseCases, authStateManager: AuthStateManaging, userUseCase: UserUseCases, userDefaultsManager: UserDefaultsManager) {
        self.useCase = useCase
        self.authStateManager = authStateManager
        self.userUseCase = userUseCase
        self.userDefaultsManager = userDefaultsManager
    }
    
    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            error = "Please fill in all fields"
            return
        }
        
        isLoading = true
        error = nil
        
        do {
            let user = try await useCase.signIn(email: email.lowercased(), password: password)
            userDefaultsManager.userUID = user.uid
            
            // Make sure isNewUser is false for login
            authStateManager.setNewUserStatus(false)
        } catch {
            print("Login error: \(error.localizedDescription)")
            self.error = error.localizedDescription
        }
        isLoading = false
    }
    
    func signInWithGoogle() async {
        isLoading = true
        error = nil
        
        do {
            let user = try await useCase.signInWithGoogle()
            print("Successfully signed in with Google: \(user.uid)")
            userDefaultsManager.userUID = user.uid
            
            // Check if this is a new user by trying to get user data
            let userData = try? await userUseCase.getUser(uid: user.uid)
            authStateManager.setNewUserStatus(userData == nil)
            
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
