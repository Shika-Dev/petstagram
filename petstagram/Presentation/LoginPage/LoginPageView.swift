//
//  LoginPageView.swift
//  petstagram
//
//  Created by Parama Artha on 26/04/25.
//

import SwiftUI

struct LoginPageView : View {
    @StateObject var viewModel : LoginPageViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: DIContainer.shared.generateLoginPageViewModel())
    }

    var body: some View {
        ScrollView {
            VStack{
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Sign In")
                    .font(Theme.Fonts.h2)
                    .foregroundStyle(Theme.Colors.dark1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                Text("Personalize your pet's page with photos, details and memories.")
                    .font(Theme.Fonts.bodyLargeRegular)
                    .foregroundStyle(Theme.Colors.dark1.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                CustomTextField(placeholder: "Email", text: $viewModel.email)
                    .padding()
                CustomTextField(placeholder: "Password", text: $viewModel.password, isPassword: true)
                    .padding(.horizontal)
                FilledButton(label: "Sign In", action: viewModel.login)
                    .padding()
                
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Theme.Colors.dark1.opacity(0.2))
                    Text("or continue with")
                        .font(Theme.Fonts.bodyLargeRegular)
                        .foregroundColor(Theme.Colors.dark1.opacity(0.5))
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Theme.Colors.dark1.opacity(0.2))
                }
                .padding(.horizontal)
                .padding(.vertical, 24)
                
                HStack{
                    Image("GoogleColored")
                    Text("Continue with Google")
                        .font(Theme.Fonts.bodyLargeSemiBold)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.Colors.dark2.opacity(0.3), lineWidth: 1)
                )
                .padding()
            }
        }
    }
}

#Preview {
    LoginPageView()
}

