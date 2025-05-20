//
//  LoginPageView.swift
//  petstagram
//
//  Created by Parama Artha on 26/04/25.
//

import SwiftUI

struct LoginPageView : View {
    @StateObject var viewModel : LoginPageViewModel
    @StateObject private var authStateManager: AuthStateManager
    
    init() {
        let di = DIContainer.shared
        _viewModel = StateObject(wrappedValue: di.generateLoginPageViewModel())
        _authStateManager = StateObject(wrappedValue: di.authStateManager)
    }

    var body: some View {
        NavigationStack {
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
                
                if let error = viewModel.error {
                    Text(error)
                        .font(Theme.Fonts.bodyRegular)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                FilledButton(
                    label: viewModel.isLoading ? "Signing in..." : "Sign In",
                    action: {
                        Task {
                            await viewModel.login()
                        }
                    }
                )
                .disabled(viewModel.isLoading)
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
                .onTapGesture {
                    Task {
                        await viewModel.signInWithGoogle()
                    }
                }

                Spacer()
                HStack{
                    Text("Do not has an account?")
                        .font(Theme.Fonts.bodyLargeRegular)
                        .foregroundStyle(Theme.Colors.dark1)
                    NavigationLink(destination: RegisterPageView().navigationBarBackButtonHidden(true)) {
                        Text("Sign Up")
                            .font(Theme.Fonts.bodyLargeRegular)
                            .foregroundStyle(Theme.Colors.primary1)
                    }
                }
            }
            .navigationDestination(isPresented: $authStateManager.isAuthenticated) {
                Group {
                    if authStateManager.isNewUser {
                        EditProfilePageView()
                            .navigationBarBackButtonHidden(true)
                    } else {
                        ContentPageView()
                            .navigationBarBackButtonHidden(true)
                    }
                }
            }
        }
    }
}

#Preview {
    LoginPageView()
}

