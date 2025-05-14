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
    private let userService: UserService
    
    init(db: Firestore, cloudinaryService: CloudinaryService, userService: UserService) {
        self.db = db
        self.cloudinaryService = cloudinaryService
        self.userService = userService
    }
    
    func uploadPost(uid: String, caption: String, image: UIImage) async throws {
        let imageURL = try await cloudinaryService.uploadImage(image)
        
        guard let user = try await userService.getUser(uid: uid) else { return }
        
        let metaBody = MetaBody(fullName: user.fullName, username: user.userName, profileImgUrl: user.profileImageUrl ?? "", createdAt: Date.now.timeIntervalSince1970)
        let postBody = PostBody(uid: uid, caption: caption, imageUrl: imageURL, metaBody: metaBody)
        
        let data = try JSONEncoder().encode(postBody)
        let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
        
        // Using merge: true to update existing fields while preserving fields not included in the update
        return try await db.collection("posts").document().setData(dict, merge: true)
    }
    
    func updateLike(postId: String, list: [String]) async throws {
        
        let data = [
            "likes": list
        ]
        
        return try await db.collection("posts").document(postId).setData(data, merge: true)
    }
    
    func updateComment(postId: String, list: [CommentBody]) async throws {
        let data = try list.map {
            try JSONSerialization.jsonObject(with: JSONEncoder().encode($0)) as? [String: Any] ?? [:]
        }
        let dict = [
            "comments": data
        ]
        
        return try await db.collection("posts").document(postId).setData(dict, merge: true)
    }
    
    func fetchPosts() async throws -> [PostResponse] {
        let documents = try await db.collection("posts").getDocuments()
        
        let posts : [PostResponse] = documents.documents.map { doc -> PostResponse in
            let data = doc.data()
            let imgUrl = data["imageUrl"] as? String ?? ""
            let caption = data["caption"] as? String ?? ""
            let likes = data["likes"] as? [String] ?? []
            let comments = data["comments"] as? [[String:Any]] ?? []
            let commentData = comments.map{CommentDataResponse(uid: $0["uid"] as? String ?? "", postId: $0["postId"] as? String ?? "", fullName: $0["fullName"] as? String ?? "", profileImgUrl: $0["profileImgUrl"] as? String ?? "", comment: $0["comment"] as? String ?? "", createdAt: $0["createdAt"] as? Double ?? 0)}
            var meta: MetaDataResponse? = nil
            if let metaData = data["metaBody"] as? [String: Any] {
                let fullName = metaData["fullName"] as? String ?? ""
                let userName = metaData["username"] as? String ?? ""
                let profileImgUrl = metaData["profileImgUrl"] as? String ?? ""
                let createdAt = metaData["createdAt"] as? Double ?? 0
                meta = MetaDataResponse(fullName: fullName, username: userName, profileImageUrl: profileImgUrl, createdAt: createdAt)
            }
            return PostResponse(
                id: doc.documentID, imgUrl: imgUrl, caption: caption, likes: likes, comments: commentData, meta: meta
            )
        }
        return posts
    }
    
    func fetchUserPosts(uid: String) async throws -> [PostResponse] {
        let documents = try await db.collection("posts")
            .whereField("uid", isEqualTo: uid)
            .getDocuments()
        
        let posts : [PostResponse] = documents.documents.map { doc -> PostResponse in
            let data = doc.data()
            let imgUrl = data["imageUrl"] as? String ?? ""
            let caption = data["caption"] as? String ?? ""
            let likes = data["likes"] as? [String] ?? []
            let comments = data["comments"] as? [[String:Any]] ?? []
            let commentData = comments.map{CommentDataResponse(uid: $0["uid"] as? String ?? "", postId: $0["postId"] as? String ?? "", fullName: $0["fullName"] as? String ?? "", profileImgUrl: $0["profileImgUrl"] as? String ?? "", comment: $0["comment"] as? String ?? "", createdAt: $0["createdAt"] as? Double ?? 0)}
            var meta: MetaDataResponse? = nil
            if let metaData = data["metaBody"] as? [String: Any] {
                let fullName = metaData["fullName"] as? String ?? ""
                let userName = metaData["username"] as? String ?? ""
                let profileImgUrl = metaData["profileImgUrl"] as? String ?? ""
                let createdAt = metaData["createdAt"] as? Double ?? 0
                meta = MetaDataResponse(fullName: fullName, username: userName, profileImageUrl: profileImgUrl, createdAt: createdAt)
            }
            return PostResponse(
                id: doc.documentID, imgUrl: imgUrl, caption: caption, likes: likes, comments: commentData, meta: meta
            )
        }
        return posts
    }
}
