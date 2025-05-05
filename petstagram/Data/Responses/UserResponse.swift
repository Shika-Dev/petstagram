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
}
