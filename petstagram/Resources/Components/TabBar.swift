//
//  TabBar.swift
//  petstagram
//
//  Created by Parama Artha on 06/05/25.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            TabButton(imageName: selectedTab == 0 ? "PawFilled" : "Paw",
                      isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            
            Spacer()
            
            TabButton(imageName: selectedTab == 1 ? "plus.app.fill" : "plus.app",
                      isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            
            Spacer()
            
            TabButton(imageName: selectedTab == 2 ? "PersonFilled" : "Person",
                      isSelected: selectedTab == 2) {
                selectedTab = 2
            }
        }
        .padding(.bottom, 16)
        .padding(.vertical, 16)
        .padding(.horizontal, 30)
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.white))
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: -2)
        )
    }
}

struct TabButton: View {
    let imageName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                if(imageName.contains(".")){
                    Image(systemName: imageName)
                        .font(.system(size: 24))
                } else{
                    Image(imageName)
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                }
            }
            .foregroundColor(isSelected ? Theme.Colors.primary1 : Theme.Colors.dark1)
        }
    }
}
