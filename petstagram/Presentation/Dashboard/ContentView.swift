//
//  ContentView.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: DIContainer.shared.generateContentViewModel())
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to Petstagram!")
                    .font(Theme.Fonts.h1)
                    .padding()
                
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

#Preview {
    ContentView()
}
