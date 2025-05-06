//
//  SelectPicturePageView.swift
//  petstagram
//
//  Created by Parama Artha on 06/05/25.
//

import SwiftUI
import PhotosUI

struct SelectPicturePageView: View {
    @StateObject private var viewModel: SelectPicturePageViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: DIContainer.shared.generateSelectPicturePageViewModel())
    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // Header
                    ZStack {
                        Text("New post")
                            .font(Theme.Fonts.bodyLargeBold)
                            .frame(maxWidth: .infinity)
                        Button("Next") {
                            viewModel.uploadPost()
                        }
                            .font(Theme.Fonts.bodyLargeRegular)
                            .foregroundColor(Theme.Colors.primary1)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Preview
                    if let selectedImage = viewModel.selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 350)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Theme.Colors.grey1)
                            .frame(height: 350)
                            .overlay(VStack{
                                Image("Image")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 48, height: 48)
                                    .opacity(0.2)
                                Text("No image selected")
                                    .font(Theme.Fonts.bodyRegular)
                                    .opacity(0.2)
                            })
                            .onTapGesture {
                                viewModel.isImagePickerPresented = true
                            }
                    }
                    
                    CustomTextField(placeholder: "Add your Caption", text: $viewModel.imageCaption, required: true, isTextArea: true
                    ).padding()
                    
                    //Error Message
                    if let error = viewModel.error {
                        Text(error)
                            .font(Theme.Fonts.bodyRegular)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                if viewModel.isLoading {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(
                            ProgressView("Loading...")
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .foregroundColor(.white)
                                .scaleEffect(1.5)
                        )
                }
            }
        }
        .sheet(isPresented: $viewModel.isImagePickerPresented) {
            ImagePicker(selectedImage: Binding(
                get: { viewModel.selectedImage },
                set: { viewModel.didSelectImage($0) }
            ))
        }
    }
}

#Preview{
    SelectPicturePageView()
}
