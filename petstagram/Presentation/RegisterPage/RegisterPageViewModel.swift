//
//  RegisterPageViewModel.swift
//  petstagram
//
//  Created by Parama Artha on 27/04/25.
//

import Foundation

@MainActor
class RegisterPageViewModel : ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var reTypePassword: String = ""
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var isAuthenticated: Bool = false
    
    private let useCase: AuthUseCases
    
    init(useCase: AuthUseCases) {
        self.useCase = useCase
    }
    
    func register() {
        guard !email.isEmpty, !password.isEmpty else {
            error = "Please fill in all fields"
            return
        }
        
        guard password == reTypePassword else {
            error = "Password does not match"
            return
        }
        
        isLoading = true
        error = nil
        
        Task {
            do {
                let user = try await useCase.signUp(email: email.lowercased(), password: password)
                print("Successfully signed up user: \(user.uid)")
                UserDefaultsManager.shared.userUID = user.uid
                isAuthenticated = true
            } catch {
                self.error = error.localizedDescription
            }
            isLoading = false
        }
    }
}
