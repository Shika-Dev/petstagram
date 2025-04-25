//
//  UserUseCases.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

protocol UserUseCases {
    func login(email: String, password: String, completion: @escaping (Result<UserEntity, Error>) -> Void)
}
