//
//  Mapper.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

class Mapper {
    static func posts(from response: PostResponse) -> PostEntity {
        return PostEntity(
            id: response.id, imgUrl: response.imgUrl, caption: response.caption, likes: response.likes, comments: response.comments.map(Mapper.comments(from:)), meta: metaData(from: response.meta)
        );
    }
    
    static func comments(from response: CommentDataResponse) -> CommentEntity {
        return CommentEntity(
            username: response.username, profileImgUrl: response.profileImgUrl, comment: response.comment
        );
    }
    
    static func metaData(from response: MetaDataResponse) -> MetaData {
        return MetaData(
            username: response.username, createdAt: response.createdAt
        );
    }
}
