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
    var isPassword: Bool = false
    @State private var showPassword: Bool = false
    var required : Bool = false
    var isTextArea: Bool = false
    
    var body: some View {
        HStack {
            Group {
                if isPassword {
                    if showPassword {
                        TextField(
                            "",
                            text: $text,
                            prompt: Text("\(placeholder) \(required ? "(required)" : "")")
                                .font(Theme.Fonts.bodyLargeMedium)
                                .foregroundStyle(Theme.Colors.dark2.opacity(0.5))
                        )
                        .textInputAutocapitalization(.never)
                    } else {
                        SecureField(
                            "",
                            text: $text,
                            prompt: Text("\(placeholder) \(required ? "(required)" : "")")
                                .font(Theme.Fonts.bodyLargeMedium)
                                .foregroundStyle(Theme.Colors.dark2.opacity(0.5))
                        )
                        .textInputAutocapitalization(.never)
                    }
                } else if isTextArea {
                    TextEditor(text: $text)
                        .font(Theme.Fonts.bodyLargeBold)
                        .foregroundStyle(Theme.Colors.dark2)
                        .frame(height: 100)
                        .overlay(
                            Text(text.isEmpty ? "\(placeholder) \(required ? "(required)" : "")" : "")
                                .font(Theme.Fonts.bodyLargeMedium)
                                .foregroundStyle(Theme.Colors.dark2.opacity(0.5))
                                .padding(.leading, 4)
                                .padding(.top, 6),
                            alignment: .topLeading
                        )
                } else {
                    TextField(
                        "",
                        text: $text,
                        prompt: Text("\(placeholder) \(required ? "(required)" : "")")
                            .font(Theme.Fonts.bodyLargeMedium)
                            .foregroundStyle(Theme.Colors.dark2.opacity(0.5))
                    )
                    .textInputAutocapitalization(.never)
                }
            }
            .font(Theme.Fonts.bodyLargeBold)
            .foregroundStyle(Theme.Colors.dark2)
            
            if isPassword {
                Button(action: {
                    showPassword.toggle()
                }) {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(isFocused ? Theme.Colors.primary1 : Theme.Colors.dark2.opacity(0.5))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isFocused ? Theme.Colors.primary1 : Theme.Colors.grey1, lineWidth: 2)
                .background(.white)
        )
        .focused($isFocused)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}
