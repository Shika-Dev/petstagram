//
//  UserService.swift
//  petstagram
//
//  Created by Parama Artha on 30/04/25.
//

import Foundation
import FirebaseFirestore
import UIKit

class UserService {
    private let db : Firestore
    private let cloudinaryService : CloudinaryService
    
    init(db: Firestore, cloudinaryService: CloudinaryService) {
        self.db = db
        self.cloudinaryService = cloudinaryService
    }
        
    func createOrUpdateUser(user: UserBody, newProfileImage: UIImage? = nil) async throws {
        var updatedUser = user
        // If there's a new image, upload it to Cloudinary
        if let image = newProfileImage {
            let imageURL = try await cloudinaryService.uploadImage(image)
            // Create a new user with the image URL
            updatedUser = user.copyWith(profileImageUrl: imageURL)
        }
        
        let data = try JSONEncoder().encode(updatedUser)
        let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
        
        // Using merge: true to update existing fields while preserving fields not included in the update
        return try await db.collection("users").document(updatedUser.uid).setData(dict, merge: true)
    }
    
    func getUser(uid: String) async throws -> UserResponse? {
        let document = try await db.collection("users").document(uid).getDocument()
        
        guard let data = document.data() else { return nil }
        
        // Convert Firestore Timestamp to Date
        var modifiedData = data
        if let timestamp = data["dateOfBirth"] as? Timestamp {
            modifiedData["dateOfBirth"] = timestamp.dateValue()
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: modifiedData)
        return try JSONDecoder().decode(UserResponse.self, from: jsonData)
    }    
} 
