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
    var likes: [String]
    var likesCount: Int
    var isLike: Bool
    let comments: [CommentEntity]
    let meta: MetaData
    
    func copyWith(isLike: Bool?, likesCount: Int?) -> PostEntity {
        return PostEntity(
            id: self.id,
            imgUrl: self.imgUrl,
            caption: self.caption,
            likes: self.likes,
            likesCount: likesCount ?? self.likesCount,
            isLike: isLike ?? self.isLike,
            comments: self.comments,
            meta: self.meta
        )
    }
}

struct MetaData: Codable {
    let fullName: String
    let username: String
    let profileImgUrl: String
    let createdAt: String
}

