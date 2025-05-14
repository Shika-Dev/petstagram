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
    var info: InfoBodyData?
    var lifeEvents: [[String:String]]?
    
    func copyWith(
        uid: String? = nil,
        fullName: String? = nil,
        userName: String? = nil,
        dateOfBirth: Date? = nil,
        bio: String? = nil,
        profileImageUrl: String? = nil,
        info: InfoBodyData? = nil,
        lifeEvents: [[String:String]]? = nil
    ) -> UserBody {
        return UserBody(
            uid: uid ?? self.uid,
            fullName: fullName ?? self.fullName,
            userName: userName ?? self.userName,
            dateOfBirth: dateOfBirth ?? self.dateOfBirth,
            bio: bio ?? self.bio,
            profileImageUrl: profileImageUrl ?? self.profileImageUrl,
            info: info ?? self.info,
            lifeEvents: lifeEvents ?? self.lifeEvents
        )
    }
}

struct InfoBodyData: Codable {
    var name: String
    var born: String
    var gender: String
    var breed: String
    var favoriteToy: String
    var habits: String
    var characteristics: String
    var favoriteFood: String
    
    func copyWith(
        name: String?,
        born: String?,
        gender: String?,
        breed: String?,
        favoriteToy: String?,
        habits: String?,
        characteristics: String?,
        favoriteFood: String?
    ) -> InfoData {
        return InfoData(name: name ?? self.name, born: born ?? self.born, gender: gender ?? self.gender, breed: breed ?? self.breed, favoriteToy: favoriteToy ?? self.favoriteToy, habits: habits ?? self.habits, characteristics: characteristics ?? self.characteristics, favoriteFood: favoriteFood ?? self.favoriteFood)
    }
}
