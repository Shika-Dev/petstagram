//
//  ButtonStyleTabBar.swift
//  petstagram
//
//  Created by Parama Artha on 12/05/25.
//

import SwiftUI

struct ButtonStyleTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            TabBarButton(imageName: selectedTab == 0 ? "PawFilled" : "Paw", label: "Info",
                      isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            
            Spacer()
            
            TabBarButton(imageName: selectedTab == 1 ? "ImageFilled" : "Image", label: "Posts",
                      isSelected: selectedTab == 1) {
                selectedTab = 1
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct TabBarButton: View {
    let imageName: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(imageName)
                .renderingMode(.template)
                .frame(width: 20, height: 20)
            Text(label)
                .font(Theme.Fonts.bodyRegular)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(isSelected ? Theme.Colors.primary1 : Theme.Colors.grey1)
        .foregroundStyle(isSelected ? .white : Theme.Colors.dark1)
        .clipShape(.capsule)
    }
}
