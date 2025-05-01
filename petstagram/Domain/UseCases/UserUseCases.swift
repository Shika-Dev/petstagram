//
//  UserUseCases.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

protocol UserUseCases {
    func getUser(uid: String) async throws -> UserEntity?
    func createOrUpdateUser(user: UserEntity) async throws -> Void
}
