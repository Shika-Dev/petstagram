//
//  PetstagramRepositories.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

protocol Repositories {
    func fetchPosts(completion: @escaping (Result<[PostEntity], Error>) -> Void)
    func login(email: String, password: String, completion: @escaping (Result<UserEntity, Error>) -> Void)
}
