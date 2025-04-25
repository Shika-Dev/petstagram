//
//  UserResponse.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

struct UserResponse: Codable {
    let email: String
    let displayName: String
    let bio: String
    let profilePictureUrl: String
    let birthday: String
}
