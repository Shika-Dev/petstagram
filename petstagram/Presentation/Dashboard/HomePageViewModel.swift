//
//  ContentViewModel.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import Foundation

@MainActor
final class HomePageViewModel: ObservableObject {
    @Published var posts: [PostEntity] = []
    @Published var error: String = ""
    @Published var isRefreshing: Bool = false
    @Published var showCommentSheet: Bool = false
    @Published var selectedPost: PostEntity?
    
    private let useCase: PostUseCases
    private let userDefaultsManager: UserDefaultsManager
    
    init(useCase: PostUseCases, userDefaultsManager: UserDefaultsManager) {
        self.useCase = useCase
        self.userDefaultsManager = userDefaultsManager
        fetchPosts()
    }
    
    func fetchPosts(){
        Task {
            do {
                isRefreshing = true
                let result = try await useCase.fetchPosts()
                posts = result
                isRefreshing = false
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
    
    func postComment(postId: String, comment:String) {
        Task {
            do {
                guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
                guard let uid = userDefaultsManager.userUID else { return }
                let fullName = userDefaultsManager.fullName ?? ""
                let profilePictureUrl = userDefaultsManager.profilePictureUrl ?? ""
                
                var updatedPost = posts[index]
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMMM yyyy HH:mm:ss"
                
                let dateString = formatter.string(from: Date.now)
                updatedPost.comments.append(CommentEntity(
                    uid: uid, postId: postId, fullName: fullName, profileImgUrl: profilePictureUrl, comment: comment, createdAt: dateString
                ))
                
                let updatedCommentCount = updatedPost.commentCount + 1
                updatedPost.commentCount = updatedCommentCount
                
                posts[index] = updatedPost
                
                // Update selectedPost if it's the same post
                if selectedPost?.id == postId {
                    selectedPost = updatedPost
                }
                
                try await useCase.updateComments(id: posts[index].id, comments: posts[index].comments)
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
    
    func updateLike(id postId: String){
        Task {
            do {
                guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
                guard let uid = userDefaultsManager.userUID else { return }
                let currentLikeStatus = posts[index].isLike
                let newLikeStatus = !currentLikeStatus
                
                var updatedPost = posts[index]
                updatedPost.isLike = newLikeStatus
                
                let updatedLikes = updatedPost.likesCount + (newLikeStatus ? 1 : -1)
                updatedPost.likesCount = updatedLikes
                
                var likesArray: [String] = posts[index].likes
                if updatedPost.isLike {
                    if !likesArray.contains(uid) {
                        likesArray.append(uid)
                    }
                } else {
                    if likesArray.contains(uid) {
                        likesArray.remove(at: likesArray.firstIndex(of: uid)!)
                    }
                }
                updatedPost.likes = likesArray
                
                posts[index] = updatedPost
                
                try await useCase.updateLike(id: posts[index].id, likes: posts[index].likes)
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
}
