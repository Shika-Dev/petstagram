//
//  CommentEntity.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

struct CommentEntity: Codable, Hashable {
    let uid: String
    let postId: String
    let fullName: String
    let profileImgUrl: String
    let comment: String
    let createdAt: String
}
