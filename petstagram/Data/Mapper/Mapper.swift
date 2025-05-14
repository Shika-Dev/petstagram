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
            id: response.id, imgUrl: response.imgUrl, caption: response.caption, likes: response.likes, likesCount: response.likes.count, commentCount: response.comments.count, isLike: response.likes.contains(uid), comments: response.comments.map{Mapper.comments(from:$0)}, meta: metaData(from: response.meta)
        )
    }
    
    static func comments(from response: CommentDataResponse) -> CommentEntity {
        var dateString = ""
        
        let date = Date(timeIntervalSince1970: response.createdAt)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy HH:mm:ss"
        
        dateString = formatter.string(from: date)
        
        return CommentEntity( uid: response.uid, postId: response.postId, fullName: response.fullName, profileImgUrl: response.profileImgUrl, comment: response.comment, createdAt: dateString
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
        
        let info = InfoData(name: response?.info?.name ?? "", born: response?.info?.born ?? "", gender: response?.info?.gender ?? "", breed: response?.info?.breed ?? "", favoriteToy: response?.info?.favoriteToy ?? "", habits: response?.info?.habits ?? "", characteristics: response?.info?.characteristics ?? "", favoriteFood: response?.info?.favoriteFood ?? "")
        
        return UserEntity(uid: response!.uid, fullName: response!.fullName, userName: response!.userName, dateOfBirth: response!.dateOfBirth, bio: response?.bio ?? "", profileImageUrl: response?.profileImageUrl ?? "", info: info, lifeEvents: response?.lifeEvents ?? [])
    }
    
    static func userBody(from entity: UserEntity) -> UserBody {
        return UserBody(uid: entity.uid, fullName: entity.fullName, userName: entity.userName, dateOfBirth: entity.dateOfBirth, bio: entity.bio, profileImageUrl: entity.profileImageUrl, info: infoBody(from: entity.info), lifeEvents: entity.lifeEvents)
    }
    
    static func infoBody(from infoData: InfoData) -> InfoBodyData {
        return InfoBodyData(name: infoData.name, born: infoData.born, gender: infoData.gender, breed: infoData.breed, favoriteToy: infoData.favoriteToy, habits: infoData.habits, characteristics: infoData.characteristics, favoriteFood: infoData.favoriteFood)
    }
    
    static func commentBody(from entity: [CommentEntity]) -> [CommentBody] {
        return entity.map{
            CommentBody(uid: $0.uid, postId: $0.postId, fullName: $0.fullName, profileImgUrl: $0.profileImgUrl, comment: $0.comment, createdAt: Date.now.timeIntervalSince1970)
        }
    }
}
