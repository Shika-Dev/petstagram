//
//  PostAdapter.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import SwiftUI

class PostUseCaseAdapter: PostUseCases {
    private let repository: Repositories
    
    init(repository: Repositories) {
        self.repository = repository
    }
    
    func fetchPosts() async throws -> [PostEntity] {
        return try await repository.fetchPosts()
    }
    
    func uploadPosts(image: UIImage, caption: String) async throws {
        return try await repository.uploadPost(image: image, caption: caption)
    }
    
    func updateLike(id postId: String, likes list: [String]) async throws {
        return try await repository.updateLike(id: postId, likes: list)
    }
}
