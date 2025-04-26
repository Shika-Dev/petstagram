//
//  ElevatedButton.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import SwiftUI

struct FilledButton : View {
    var label: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(Theme.Fonts.h6)
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .background(Theme.Colors.primary1)
                .clipShape(.capsule)
        }
    }
}

struct OutlinedButton : View {
    var label: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(Theme.Fonts.h6)
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundStyle(Theme.Colors.primary1)
                .clipShape(.capsule)
                .border(Theme.Colors.primary1)
        }
    }
}
