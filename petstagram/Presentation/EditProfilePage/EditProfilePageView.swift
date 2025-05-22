//
//  EditProfilePageView.swift
//  petstagram
//
//  Created by Parama Artha on 30/04/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct EditProfilePageView: View {
    @StateObject var viewModel: EditProfilePageViewModel
    @Environment(\.pixelLength) private var pixelLength
    
    init() {
        let di = DIContainer.shared
        _viewModel = StateObject(wrappedValue: di.generateEditProfilePageViewModel())
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                // Profile Image Section
                ZStack {
                    Circle()
                        .fill(Theme.Colors.grey1)
                        .frame(width: 108, height: 108)
                        .accessibilityIdentifier("ProfileImage")
                    
                    if let selectedImage = viewModel.selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 108, height: 108)
                            .clipShape(Circle())
                    } else if let imageUrl = viewModel.profileImageUrl {
                        WebImage(url: URL(string: imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 108, height: 108)
                            .clipShape(Circle())
                    } else {
                        Image("Image")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .opacity(0.2)
                    }
                }
                .padding(.top, 24)
                .onTapGesture {
                    viewModel.isImagePickerPresented = true
                }
                .accessibilityElement(children: .contain)
                
                // Form Fields
                VStack(spacing: 16) {
                    CustomTextField(placeholder: "Full name", text: $viewModel.fullName, required: true)
                    
                    CustomTextField(placeholder: "User name", text: $viewModel.userName, required: true)
                    
                    // Date Picker
                    HStack {
                        Text(viewModel.dateOfBirth, style: .date)
                            .font(Theme.Fonts.bodyLargeRegular)
                            .foregroundColor(Theme.Colors.dark1)
                        
                        Spacer()
                        
                        DatePicker("", selection: $viewModel.dateOfBirth, displayedComponents: .date)
                            .labelsHidden()
                            .accessibilityIdentifier("DatePicker")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Theme.Colors.grey1, lineWidth: 2)
                    )
                    
                    CustomTextField(placeholder: "Bio", text: $viewModel.bio, isTextArea: true)
                }
                .accessibilityElement(children: .contain)
                .padding(.horizontal)
                
                if let error = viewModel.error {
                    Text(error)
                        .font(Theme.Fonts.bodyRegular)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
            }
        }
        .padding(.top, pixelLength)
        .safeAreaInset(edge: .bottom){
            // Continue Button
            FilledButton(
                label: viewModel.isLoading ? "Saving..." : "Continue",
                action: viewModel.updateProfile
            )
            .disabled(viewModel.isLoading)
            .padding()
        }
        .accessibilityIdentifier("EditProfilePage")
        .sheet(isPresented: $viewModel.isImagePickerPresented) {
            ImagePicker(selectedImage: Binding(
                get: { viewModel.selectedImage },
                set: { viewModel.didSelectImage($0) }
            ))
            .accessibilityIdentifier("ImagePicker")
        }
        .navigationDestination(isPresented: $viewModel.isProfileSaved) {
            ContentPageView()
                .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    EditProfilePageView()
}
