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
    
    static func user(from response: UserResponse?) -> UserEntity? {
        guard response != nil else {
            return nil
        }
        return UserEntity(uid: response!.uid, fullName: response!.fullName, userName: response!.userName, dateOfBirth: response!.dateOfBirth, bio: response?.bio ?? "", profileImageBase64: response?.profileImageBase64 ?? "")
    }
    
    static func userBody(from entity: UserEntity) -> UserBody {
        return UserBody(uid: entity.uid, fullName: entity.fullName, userName: entity.userName, dateOfBirth: entity.dateOfBirth, bio: entity.bio, profileImageBase64: entity.profileImageBase64)
    }
}
