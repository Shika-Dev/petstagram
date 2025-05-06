//
//  ContentPageView.swift
//  petstagram
//
//  Created by Parama Artha on 06/05/25.
//

import SwiftUI

struct ContentPageView: View {
    @State private var selectedTab = 0
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomePageView()
                    .tag(0)
                
                SelectPicturePageView()
                    .tag(1)
                
                EditProfilePageView()
                    .tag(2)
            }
            
            // Custom tab bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentPageView()
}
