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
    @Published var profileImageUrl: String?
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var selectedImage: UIImage?
    @Published var isImagePickerPresented: Bool = false
    @Published var isProfileSaved: Bool = false
    
    private let useCase : UserUseCases
    
    init(useCase : UserUseCases){
        self.useCase = useCase
        loadUserProfile()
    }
    
    private func loadUserProfile() {
        guard let uid = UserDefaultsManager.shared.userUID else { return }
        
        Task {
            do {
                if let user = try await useCase.getUser(uid: uid) {
                    fullName = user.fullName
                    userName = user.userName
                    dateOfBirth = user.dateOfBirth
                    bio = user.bio ?? ""
                    profileImageUrl = user.profileImageUrl
                }
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
    
    func updateProfile() {
        guard !fullName.isEmpty, !userName.isEmpty else {
            error = "Please fill in all required fields"
            return
        }
        
        guard let uid = UserDefaultsManager.shared.userUID else {
            error = "User not authenticated"
            return
        }
        
        isLoading = true
        error = nil
        
        Task {
            do {
                let user = UserEntity(
                    uid: uid,
                    fullName: fullName,
                    userName: userName,
                    dateOfBirth: dateOfBirth,
                    bio: bio
                )
                
                // Pass the new image if there is one, otherwise just update the text fields
                try await useCase.createOrUpdateUser(
                    user: user,
                    newImage: selectedImage
                )
                
                isProfileSaved = true
            } catch {
                self.error = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    func didSelectImage(_ image: UIImage?) {
        self.selectedImage = image
    }
}
