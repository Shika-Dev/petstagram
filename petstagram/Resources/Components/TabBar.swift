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
                      isSelected: selectedTab == 0, identifier: "Home") {
                selectedTab = 0
            }
            
            Spacer()
            
            TabButton(imageName: selectedTab == 1 ? "plus.app.fill" : "plus.app",
                      isSelected: selectedTab == 1, identifier: "AddPost") {
                selectedTab = 1
            }
            
            Spacer()
            
            TabButton(imageName: selectedTab == 2 ? "PersonFilled" : "Person",
                      isSelected: selectedTab == 2, identifier: "Profile") {
                selectedTab = 2
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 30)
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .background(
            UnevenRoundedRectangle(topLeadingRadius: 15, topTrailingRadius: 15)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: -2)
                    .ignoresSafeArea()
        )
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("NavigationBar")
    }
}

struct TabButton: View {
    let imageName: String
    let isSelected: Bool
    let identifier: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Group {
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
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier(imageName)
        }
        .accessibilityIdentifier(identifier)
    }
}
