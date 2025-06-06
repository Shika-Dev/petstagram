//
//  SelectPicturePageViewModel.swift
//  petstagram
//
//  Created by Parama Artha on 06/05/25.
//

import SwiftUI
import PhotosUI

@MainActor
class SelectPicturePageViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var isImagePickerPresented: Bool = false
    @Published var imageCaption: String = ""
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var isPostSaved: Bool = false
    
    private let useCase : PostUseCases
    
    init(useCase : PostUseCases){
        self.useCase = useCase
    }
    
    func uploadPost() async {
        guard !imageCaption.isEmpty, selectedImage != nil else {
            error = "Please fill in all required fields"
            return
        }
            
        isLoading = true
        error = nil
        
        do {
            try await useCase.uploadPosts(image: selectedImage!, caption: imageCaption)
            isLoading = false
            isPostSaved = true
        } catch {
            self.error = error.localizedDescription
            isLoading = false
        }
    }
    
    func didSelectImage(_ image: UIImage?) {
        self.selectedImage = image
    }
}
