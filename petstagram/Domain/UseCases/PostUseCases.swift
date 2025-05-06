//
//  PostUseCases.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import SwiftUI

protocol PostUseCases {
    func fetchPosts(completion: @escaping (Result<[PostEntity], Error>) -> Void)
    func uploadPosts(image: UIImage, caption: String) async throws -> Void
}
