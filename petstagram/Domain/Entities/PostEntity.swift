//
//  PostEntity.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

struct PostEntity: Identifiable, Codable {
    let id: String
    let imgUrl: String
    let caption: String
    let likes: Int
    let comments: [CommentEntity]
    let meta: MetaData
}

struct MetaData: Codable {
    let username: String
    let createdAt: String
}
