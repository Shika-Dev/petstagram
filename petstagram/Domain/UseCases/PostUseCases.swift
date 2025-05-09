//
//  PostUseCases.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import SwiftUI

protocol PostUseCases {
    func fetchPosts() async throws -> [PostEntity]
    func uploadPosts(image: UIImage, caption: String) async throws -> Void
    func updateLike(id postId: String, likes list: [String]) async throws -> Void
}
