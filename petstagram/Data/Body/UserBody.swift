//
//  UserBody.swift
//  petstagram
//
//  Created by Parama Artha on 30/04/25.
//

import Foundation

struct UserBody : Codable {
    let uid: String
    let fullName: String
    let userName: String
    let dateOfBirth: Date
    let bio: String?
    var profileImageBase64: String?
}
