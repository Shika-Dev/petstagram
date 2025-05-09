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
    private let useCase: PostUseCases
    
    init(useCase: PostUseCases) {
        self.useCase = useCase
        fetchPosts()
    }
    
    func fetchPosts(){
        Task {
            do {
                isRefreshing = true
                let result = try await useCase.fetchPosts()
                posts = result
                isRefreshing = false
                print("refresh successfull")
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
    
    func updateLike(id postId: String){
        Task {
            do {
                guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
                guard let uid = UserDefaultsManager.shared.userUID else { return }
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
