//
//  PostAdapter.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

class PostUseCaseAdapter: PostUseCases {
    private let repository: Repositories
    
    init(repository: Repositories) {
        self.repository = repository
    }
    
    func fetchPosts(completion: @escaping(Result<[PostEntity], Error>)-> Void) {
        repository.fetchPosts(completion: completion)
    }
}
