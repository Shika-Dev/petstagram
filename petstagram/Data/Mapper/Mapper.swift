//
//  Mapper.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import Foundation

class Mapper {
    static func posts(from response: PostResponse, uid: String) -> PostEntity {
        return PostEntity(
            id: response.id, imgUrl: response.imgUrl, caption: response.caption, likes: response.likes, likesCount: response.likes.count, isLike: response.likes.contains(uid), comments: response.comments.map(Mapper.comments(from:)), meta: metaData(from: response.meta)
        )
    }
    
    static func comments(from response: CommentDataResponse) -> CommentEntity {
        return CommentEntity(
            username: response.username, profileImgUrl: response.profileImgUrl, comment: response.comment
        )
    }
    
    static func metaData(from response: MetaDataResponse?) -> MetaData {
        var dateString = ""
        
        if(response?.createdAt != nil) {
            let date = Date(timeIntervalSince1970: response!.createdAt)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy HH:mm:ss"
            
            dateString = formatter.string(from: date)
        }

        return MetaData(
            fullName: response?.fullName ?? "", username: response?.username ?? "", profileImgUrl: response?.profileImageUrl ?? "", createdAt: dateString
        )
    }
    
    static func user(from response: UserResponse?) -> UserEntity? {
        guard response != nil else {
            return nil
        }
        return UserEntity(uid: response!.uid, fullName: response!.fullName, userName: response!.userName, dateOfBirth: response!.dateOfBirth, bio: response?.bio ?? "", profileImageUrl: response?.profileImageUrl ?? "")
    }
    
    static func userBody(from entity: UserEntity) -> UserBody {
        return UserBody(uid: entity.uid, fullName: entity.fullName, userName: entity.userName, dateOfBirth: entity.dateOfBirth, bio: entity.bio, profileImageUrl: entity.profileImageUrl)
    }
}
