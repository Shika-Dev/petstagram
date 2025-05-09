//
//  ContentView.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomePageView: View {
    @StateObject private var viewModel: HomePageViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: DIContainer.shared.generateHomePageViewModel())
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack {
                        Image("AppLogo")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("Petstagram")
                            .font(Theme.Fonts.h4)
                            .offset(x:-15)
                            .padding()
                        Spacer()
                    }
                    ForEach(viewModel.posts) { post in
                        PostElementView(post: post, viewModel: viewModel)
                    }
                }
                .padding(.horizontal)
                .navigationBarTitleDisplayMode(.inline)
            }
            .refreshable {
                viewModel.fetchPosts()
            }
        }
    }
}

struct PostElementView : View {
    var post: PostEntity
    var viewModel: HomePageViewModel
    var body: some View {
        VStack(alignment: .leading){
            HStack(spacing: 16){
                WebImage(url: URL(string: post.meta.profileImgUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                VStack(alignment: .leading){
                    Text(post.meta.fullName)
                        .font(Theme.Fonts.bodySemiBold)
                    Text(post.meta.username)
                        .font(Theme.Fonts.bodyMedium)
                }
            }
            WebImage(url: URL(string: post.imgUrl))
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            HStack() {
                Image(systemName: post.isLike ? "heart.fill" : "heart")
                    .font(.system(size: 24))
                    .foregroundStyle(post.isLike ? Theme.Colors.primary1 : Theme.Colors.dark1)
                    .onTapGesture {
                        viewModel.updateLike(id: post.id)
                    }
                Text("\(post.likesCount)")
                    .font(Theme.Fonts.bodyLargeMedium)
                    .foregroundStyle(Theme.Colors.dark1)
                    .padding(.trailing)
                Image(systemName: "message")
                    .font(.system(size: 24))
                    .foregroundStyle(Theme.Colors.dark1)
            }
            .padding(.vertical, 8)
            Text(post.caption)
                .font(Theme.Fonts.bodyMedium)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 2)
            Text(post.meta.createdAt)
                .font(Theme.Fonts.bodySmallRegular)
        }
    }
}

struct RefreshableContent<Content: View>: View {
    var refreshAction: () async -> Void
    var isRefreshing: Bool
    let content: Content
    
    init(refreshAction: @escaping () async -> Void, isRefreshing: Bool, @ViewBuilder content: () -> Content) {
        self.refreshAction = refreshAction
        self.isRefreshing = isRefreshing
        self.content = content()
    }
    
    var body: some View {
        content
            .refreshable {
                await refreshAction()
            }
            .overlay(alignment: .top) {
                if isRefreshing {
                    ProgressView()
                        .tint(Theme.Colors.primary1)
                        .padding(.top, 10)
                }
            }
    }
}

#Preview {
    HomePageView()
}
