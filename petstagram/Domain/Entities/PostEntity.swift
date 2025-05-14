//
//  PostEntity.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

struct PostEntity: Identifiable, Codable, Hashable {
    let id: String
    let imgUrl: String
    let caption: String
    var likes: [String]
    var likesCount: Int
    var commentCount: Int
    var isLike: Bool
    var comments: [CommentEntity]
    let meta: MetaData
    
    func copyWith(isLike: Bool?, likesCount: Int?, commentCount: Int?) -> PostEntity {
        return PostEntity(
            id: self.id,
            imgUrl: self.imgUrl,
            caption: self.caption,
            likes: self.likes,
            likesCount: likesCount ?? self.likesCount,
            commentCount: commentCount ?? self.commentCount,
            isLike: isLike ?? self.isLike,
            comments: self.comments,
            meta: self.meta
        )
    }
}

struct MetaData: Codable, Hashable {
    let fullName: String
    let username: String
    let profileImgUrl: String
    let createdAt: String
}

