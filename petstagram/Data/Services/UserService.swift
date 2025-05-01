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
    private let db = Firestore.firestore()
    
    func createOrUpdateUser(user: UserBody) async throws {
        let data = try JSONEncoder().encode(user)
        let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
        
        // Using merge: true to update existing fields while preserving fields not included in the update
        try await db.collection("users").document(user.uid).setData(dict, merge: true)
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
