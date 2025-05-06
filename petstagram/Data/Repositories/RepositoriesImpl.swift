//
//  PetstagramRepositoriesImpl.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import FirebaseAuth
import GoogleSignIn

class RepositoriesImpl : Repositories {
    private let authService: AuthService
    private let userService: UserService
    private let postService: PostService
    
    init(authService: AuthService, userService: UserService, postService: PostService) {
        self.authService = authService
        self.userService = userService
        self.postService = postService
    }
    
    func fetchPosts(completion: @escaping (Result<[PostEntity], Error>) -> Void) {
        
    }
    
    func uploadPost(image: UIImage, caption: String) async throws {
        guard let uid = await UserDefaultsManager.shared.userUID else { return }
        
        return try await postService.uploadPost(uid: uid, caption: caption, image: image)
    }
    
    func signIn(email: String, password: String) async throws -> User {
        return try await authService.signIn(email: email, password: password)
    }
    
    func signInWithGoogle() async throws -> User {
        return try await authService.signInWithGoogle()
    }
    
    func signUp(email: String, password: String) async throws -> User {
        return try await authService.signUp(email: email, password: password)
    }
    
    func getUser(uid: String) async throws -> UserEntity? {
        let user = try await userService.getUser(uid: uid)
        return Mapper.user(from: user)
    }
    
    func createOrUpdateUser(user: UserEntity, newImage: UIImage?) async throws {
        let userBody = Mapper.userBody(from: user)
        return try await userService.createOrUpdateUser(user: userBody, newProfileImage: newImage)
    }
}
