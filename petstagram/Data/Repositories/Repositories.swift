//
//  PetstagramRepositories.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import FirebaseAuth
import GoogleSignIn
import UIKit

protocol Repositories {
    func fetchPosts() async throws -> [PostEntity]
    func fetchUserPosts() async throws -> [PostEntity]
    func uploadPost(image: UIImage, caption: String) async throws -> Void
    func signIn(email: String, password: String) async throws -> User
    func signInWithGoogle() async throws -> User
    func signUp(email: String, password: String) async throws -> User
    func getUser(uid: String) async throws -> UserEntity?
    func createOrUpdateUser(user: UserEntity, newImage: UIImage?) async throws -> Void
    func updateLike(id postId: String, likes list: [String]) async throws -> Void
    func updateComments(id postId: String, comments list: [CommentEntity]) async throws -> Void
}
