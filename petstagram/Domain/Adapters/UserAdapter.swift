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
    
    func login(email: String, password: String, completion: @escaping(Result<UserEntity, Error>)-> Void) {
        repository.login(email: email, password: password, completion: completion)
    }
}
