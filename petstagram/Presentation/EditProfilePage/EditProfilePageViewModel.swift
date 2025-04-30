//
//  EditProfilePageViewModel.swift
//  petstagram
//
//  Created by Parama Artha on 30/04/25.
//

import Foundation
import UIKit

@MainActor
class EditProfilePageViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var userName: String = ""
    @Published var dateOfBirth: Date = Date()
    @Published var bio: String = ""
    @Published var phoneNumber: String = ""
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var selectedImage: UIImage?
    @Published var isImagePickerPresented: Bool = false
    
    private let useCase : UserUseCases
    
    init(useCase : UserUseCases){
        self.useCase = useCase
    }

    
    func updateProfile() {
        guard !fullName.isEmpty, !userName.isEmpty else {
            error = "Please fill in all required fields"
            return
        }
        
        isLoading = true
        error = nil
        
        // TODO: Implement profile update logic
        
        isLoading = false
    }
    
    func didSelectImage(_ image: UIImage?) {
        self.selectedImage = image
    }
}

