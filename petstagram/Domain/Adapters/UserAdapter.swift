//
//  UserAdapter.swift
//  petstagram
//
//  Created by Parama Artha on 26/04/25.
//

import UIKit

class UserUseCaseAdapter: UserUseCases {
    private let repository: Repositories
    
    init(repository: Repositories) {
        self.repository = repository
    }
    
    func getUser(uid: String) async throws -> UserEntity? {
        return try await repository.getUser(uid: uid)
    }
    
    func createOrUpdateUser(user: UserEntity, newImage: UIImage?) async throws {
        return try await repository.createOrUpdateUser(user: user, newImage: newImage)
    }
}
