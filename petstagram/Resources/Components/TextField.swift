//
//  TextField.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import SwiftUI

struct CustomTextField : View {
    var placeholder: String
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        TextField(
            "",
            text: $text,
            prompt: Text(placeholder)
                .font(Theme.Fonts.bodyLargeMedium)
                .foregroundStyle(Theme.Colors.dark2.opacity(0.5))
        )
        .font(Theme.Fonts.bodyLargeBold)
            .foregroundStyle(Theme.Colors.dark2)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isFocused ? Theme.Colors.primary1 : Theme.Colors.dark1, lineWidth: 1)
                    .background(.white)
            )
            .focused($isFocused)
            .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}
