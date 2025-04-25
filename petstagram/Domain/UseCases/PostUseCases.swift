//
//  PostUseCases.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

protocol PostUseCases {
    func fetchPosts(completion: @escaping (Result<[PostEntity], Error>) -> Void)
}
