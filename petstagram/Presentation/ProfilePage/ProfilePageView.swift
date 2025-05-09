//
//  ProfilePageView.swift
//  petstagram
//
//  Created by Parama Artha on 08/05/25.
//

import SwiftUI

struct ProfilePageView : View {
    @StateObject private var viewModel: ProfilePageViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: DIContainer.shared.generateProfilePageViewModel())
    }
    
    var body : some View {
        NavigationStack {
            ZStack {
                VStack {
                    NavigationLink(destination: EditProfilePageView()){
                        Button(action: viewModel.signOut) {
                            Text("Edit Profile")
                                .font(Theme.Fonts.bodyLargeSemiBold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.Colors.primary1)
                                .cornerRadius(16)
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    Button(action: viewModel.signOut) {
                        Text("Sign Out")
                            .font(Theme.Fonts.bodyLargeSemiBold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.Colors.primary1)
                            .cornerRadius(16)
                    }
                    .padding()
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }

    }
}
