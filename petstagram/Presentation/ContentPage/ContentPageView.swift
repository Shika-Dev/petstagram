//
//  ContentPageView.swift
//  petstagram
//
//  Created by Parama Artha on 06/05/25.
//

import SwiftUI

struct ContentPageView: View {
    @State private var selectedTab = 0
    @Environment(\.pixelLength) private var pixelLength
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomePageView()
                .toolbarVisibility(.hidden, for: .tabBar)
                .tag(0)
            
            SelectPicturePageView()
                .toolbarVisibility(.hidden, for: .tabBar)
                .tag(1)
            
            ProfilePageView()
                .toolbarVisibility(.hidden, for: .tabBar)
                .tag(2)
        }
        .padding(.bottom, pixelLength)
        .padding(.top, pixelLength)
        .safeAreaInset(edge: .bottom) {
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    ContentPageView()
}
