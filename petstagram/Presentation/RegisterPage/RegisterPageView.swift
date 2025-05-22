//
//  RegisterPageView.swift
//  petstagram
//
//  Created by Parama Artha on 27/04/25.
//

import SwiftUI

struct RegisterPageView: View {
    @StateObject var viewModel: RegisterPageViewModel
    @Environment(\.dismiss) private var dismiss
    
    init() {
        let di = DIContainer.shared
        _viewModel = StateObject(wrappedValue: di.generateRegisterPageViewModel())
    }
    
    var body: some View {
        VStack{
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Sign Up")
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
            CustomTextField(placeholder: "Re-Type Password", text: $viewModel.reTypePassword, isPassword: true)
                .padding()
            
            if let error = viewModel.error {
                Text(error)
                    .font(Theme.Fonts.bodyRegular)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            
            FilledButton(
                label: viewModel.isLoading ? "Signing up..." : "Sign Up",
                action: {
                    Task {
                        await viewModel.register()
                    }
                }
            )
            .disabled(viewModel.isLoading)
            .padding()
            Spacer()
            HStack{
                Text("Already has an account?")
                    .font(Theme.Fonts.bodyLargeRegular)
                    .foregroundStyle(Theme.Colors.dark1)
                Text("Sign In")
                    .font(Theme.Fonts.bodyLargeRegular)
                    .foregroundStyle(Theme.Colors.primary1)
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
    }
}

#Preview {
    RegisterPageView()
}
