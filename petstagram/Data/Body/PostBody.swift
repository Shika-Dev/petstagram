//
//  PostBody.swift
//  petstagram
//
//  Created by Parama Artha on 06/05/25.
//

struct PostBody : Codable {
    var uid: String
    var caption: String
    var imageUrl: String
    
    func copyWith(uid: String? = nil, caption: String? = nil, imageUrl: String? = nil) -> PostBody {
        return PostBody(uid: uid ?? self.uid, caption: caption ?? self.caption, imageUrl: imageUrl ?? self.imageUrl)
    }
}
