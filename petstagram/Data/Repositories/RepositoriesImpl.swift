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
    private let userDefaultsManager: UserDefaultsManager
    
    init(authService: AuthService, userService: UserService, postService: PostService, userDefaultsManager: UserDefaultsManager) {
        self.authService = authService
        self.userService = userService
        self.postService = postService
        self.userDefaultsManager = userDefaultsManager
    }
    
    func fetchPosts() async throws -> [PostEntity] {
        let uid = await userDefaultsManager.userUID ?? ""
        let posts = try await postService.fetchPosts()
        let result = posts.map { post -> PostEntity in
            return Mapper.posts(from: post, uid: uid)
        }
        
        return result
    }
    
    func fetchUserPosts() async throws -> [PostEntity] {
        let uid = await userDefaultsManager.userUID ?? ""
        let posts = try await postService.fetchUserPosts(uid: uid)
        let result = posts.map { post -> PostEntity in
            return Mapper.posts(from: post, uid: uid)
        }
        
        return result
    }
    
    func uploadPost(image: UIImage, caption: String) async throws {
        guard let uid = await userDefaultsManager.userUID else { return }
        
        return try await postService.uploadPost(uid: uid, caption: caption, image: image)
    }
    
    func updateLike(id postId: String, likes list: [String]) async throws {
        return try await postService.updateLike(postId: postId, list: list)
    }
    
    func updateComments(id postId: String, comments list: [CommentEntity]) async throws {
        return try await postService.updateComment(postId: postId, list: Mapper.commentBody(from: list))
    }
    
    func signIn(email: String, password: String) async throws -> AuthUser {
        return try await authService.signIn(email: email, password: password)
    }
    
    func signInWithGoogle() async throws -> AuthUser {
        return try await authService.signInWithGoogle()
    }
    
    func signUp(email: String, password: String) async throws -> AuthUser {
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
