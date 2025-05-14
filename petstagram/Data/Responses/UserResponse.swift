//
//  UserResponse.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import Foundation

struct UserResponse: Codable {
    let uid: String
    let fullName: String
    let userName: String
    let dateOfBirth: Date
    let bio: String?
    var profileImageUrl: String?
    var info: InfoResponseData?
    var lifeEvents: [[String:String]]?
}

struct InfoResponseData: Codable {
    var name: String
    var born: String
    var gender: String
    var breed: String
    var favoriteToy: String?
    var habits: String?
    var characteristics: String?
    var favoriteFood: String?
}
