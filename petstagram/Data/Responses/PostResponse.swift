//
//  PostResponse.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

struct PostResponse: Codable {
    let id: String
    let imgUrl: String
    let caption: String
    let likes: Int
    let comments: [CommentDataResponse]
    let meta: MetaDataResponse
}

struct CommentDataResponse: Codable {
    let username: String
    let profileImgUrl: String
    let comment: String
}

struct MetaDataResponse: Codable {
    let username: String
    let createdAt: String
}
