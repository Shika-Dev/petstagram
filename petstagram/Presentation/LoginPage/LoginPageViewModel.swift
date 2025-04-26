//
//  LoginPageViewModel.swift
//  petstagram
//
//  Created by Parama Artha on 26/04/25.
//

import Foundation

class LoginPageViewModel: ObservableObject {
    private let usecase: UserUseCases
        
    init(usecase: UserUseCases){
        self.usecase = usecase
    }
    
    @Published var email: String = "" {
        didSet{
            validateForm()
        }
    }
    @Published var password: String = "" {
        didSet{
            validateForm()
        }
    }
    var isSaveDisabled: Bool = true
    
    private func validateForm(){
        isSaveDisabled = email.trimmingCharacters(in: .whitespaces).isEmpty && password.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func login(){
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {return }
        guard !password.trimmingCharacters(in: .whitespaces).isEmpty else {return }
    }
}
