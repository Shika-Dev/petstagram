//
//  UserAdapter.swift
//  petstagram
//
//  Created by Parama Artha on 26/04/25.
//

class UserUseCaseAdapter: UserUseCases {
    private let repository: Repositories
    
    init(repository: Repositories) {
        self.repository = repository
    }
    
    func getUser(uid: String) async throws -> UserEntity? {
        return try await repository.getUser(uid: uid)
    }
    
    func createOrUpdateUser(user: UserEntity) async throws {
        return try await repository.createOrUpdateUser(user: user)
    }
}
