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
            .scrollIndicators(.hidden)
            .refreshable {
                viewModel.fetchPosts()
            }
        }
    }
}

struct PostElementView : View {
    var post: PostEntity
    @ObservedObject var viewModel: HomePageViewModel
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
                    .onTapGesture {
                        viewModel.selectedPost = post
                        viewModel.showCommentSheet = true
                    }
                Text("\(post.commentCount)")
                    .font(Theme.Fonts.bodyLargeMedium)
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
        .padding(.bottom, 12)
        .sheet(isPresented: $viewModel.showCommentSheet) {
            if let selectedPost = viewModel.selectedPost {
                CommentSheetView(post: selectedPost, viewModel: viewModel)
            }
        }
    }
}

struct CommentSheetView: View {
    var post: PostEntity
    @ObservedObject var viewModel: HomePageViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var commentText = ""
    @State private var scrollProxy: ScrollViewProxy?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        CommentSectionView(post: post)
                    }
                    .onAppear {
                        scrollProxy = proxy
                    }
                }
                
                Divider()
                
                HStack(spacing: 12) {
                    CustomTextField(
                        placeholder: "Add a comment...",
                        text: $commentText,
                        isTextArea: false
                    )
                    .frame(height: 40)
                    
                    Button(action: {
                        viewModel.postComment(postId: post.id, comment: commentText)
                        commentText = ""
                    }) {
                        Image("PaperplaneFilled")
                            .renderingMode(.template)
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Theme.Colors.primary1)
                            .rotationEffect(Angle(degrees: 315))
                    }
                    .disabled(commentText.isEmpty)
                }
                .padding()
                .background(.white)
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(32)
    }
}

#Preview {
    HomePageView()
}

struct CommentSectionView: View {
    let post: PostEntity
    var body: some View {

        LazyVStack(alignment: .leading, spacing: 16) {
            ForEach(post.comments, id: \.self) { comment in
                HStack(alignment: .top, spacing: 12) {
                    WebImage(url: URL(string: comment.profileImgUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(comment.fullName)
                            .font(Theme.Fonts.bodySemiBold)
                        Text(comment.comment)
                            .font(Theme.Fonts.bodyRegular)
                        Text(comment.createdAt)
                            .font(Theme.Fonts.bodySmallRegular)
                            .foregroundStyle(Theme.Colors.dark1.opacity(0.6))
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}
