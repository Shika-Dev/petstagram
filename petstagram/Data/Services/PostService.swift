//
//  PostService.swift
//  petstagram
//
//  Created by Parama Artha on 06/05/25.
//

import FirebaseFirestore

class PostService {
    private let db : Firestore
    private let cloudinaryService : CloudinaryService
    
    init(db: Firestore, cloudinaryService: CloudinaryService) {
        self.db = db
        self.cloudinaryService = cloudinaryService
    }
    
    func uploadPost(uid: String, caption: String, image: UIImage) async throws {
        let imageURL = try await cloudinaryService.uploadImage(image)
        let postBody = PostBody(uid: uid, caption: caption, imageUrl: imageURL)
        
        let data = try JSONEncoder().encode(postBody)
        let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
        
        // Using merge: true to update existing fields while preserving fields not included in the update
        return try await db.collection("posts").document().setData(dict, merge: true)
    }
}
