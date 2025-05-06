//
//  UserBody.swift
//  petstagram
//
//  Created by Parama Artha on 30/04/25.
//

import Foundation

struct UserBody : Codable {
    var uid: String
    var fullName: String
    var userName: String
    var dateOfBirth: Date
    var bio: String?
    var profileImageUrl: String?
    
    func copyWith(
        uid: String? = nil,
        fullName: String? = nil,
        userName: String? = nil,
        dateOfBirth: Date? = nil,
        bio: String? = nil,
        profileImageUrl: String? = nil
    ) -> UserBody {
        return UserBody(
            uid: uid ?? self.uid,
            fullName: fullName ?? self.fullName,
            userName: userName ?? self.userName,
            dateOfBirth: dateOfBirth ?? self.dateOfBirth,
            bio: bio ?? self.bio,
            profileImageUrl: profileImageUrl ?? self.profileImageUrl
        )
    }
}
