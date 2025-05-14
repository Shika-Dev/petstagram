//
//  CommentBody.swift
//  petstagram
//
//  Created by Parama Artha on 14/05/25.
//

struct CommentBody: Codable {
    let uid: String
    let postId: String
    let fullName: String
    let profileImgUrl: String
    let comment: String
    let createdAt: Double
}

