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
    
    func fetchPosts(completion: @escaping(Result<[PostEntity], Error>)-> Void) {
        repository.fetchPosts(completion: completion)
    }
    
    func uploadPosts(image: UIImage, caption: String) async throws {
        return try await repository.uploadPost(image: image, caption: caption)
    }
}
