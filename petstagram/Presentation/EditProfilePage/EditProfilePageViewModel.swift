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
    
    private var info: InfoData = InfoData.empty()
    private var lifeEvents: [[String:String]] = []
    
    private let useCase : UserUseCases
    private let userDefaultsManager: UserDefaultsManager
    
    init(useCase : UserUseCases, userDefaultsManager: UserDefaultsManager){
        self.useCase = useCase
        self.userDefaultsManager = userDefaultsManager
        loadUserProfile()
    }
    
    private func loadUserProfile() {
        guard let uid = userDefaultsManager.userUID else { return }
        
        Task {
            do {
                if let user = try await useCase.getUser(uid: uid) {
                    fullName = user.fullName
                    userName = user.userName
                    dateOfBirth = user.dateOfBirth
                    bio = user.bio ?? ""
                    profileImageUrl = user.profileImageUrl
                    info = user.info
                    lifeEvents = user.lifeEvents
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
        
        guard let uid = userDefaultsManager.userUID else {
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
                    bio: bio,
                    info: info,
                    lifeEvents: lifeEvents
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
