//
//  UserEntity.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import Foundation

struct UserEntity: Codable {
    let uid: String
    let fullName: String
    let userName: String
    let dateOfBirth: Date
    let bio: String?
    var profileImageUrl: String?
    var info: InfoData
    var lifeEvents: [[String:String]]
}

struct InfoData: Codable {
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
    
    static func empty() -> InfoData {
        return InfoData(name: "", born: "", gender: "", breed: "", favoriteToy: "", habits: "", characteristics: "", favoriteFood: "")
    }
}
