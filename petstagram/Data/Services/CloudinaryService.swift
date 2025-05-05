//
//  CloudinaryService.swift
//  petstagram
//
//  Created by Parama Artha on 05/05/25.
//

import Foundation
import UIKit

class CloudinaryService {
    private let cloudName: String
    private let apiKey: String
    private let apiSecret: String
    private let uploadPreset: String
    
    private let uploadURL: String
    
    init() {
        // Load all values from environment config
        self.cloudName = EnvironmentConfig.cloudinaryCloudName
        self.apiKey = EnvironmentConfig.cloudinaryApiKey
        self.apiSecret = EnvironmentConfig.cloudinaryApiSecret
        self.uploadPreset = EnvironmentConfig.cloudinaryUploadPreset
        
        // Use the upload preset URL for unsigned uploads (more secure for mobile apps)
        self.uploadURL = "https://api.cloudinary.com/v1_1/\(cloudName)/image/upload"
    }
    
    func uploadImage(_ image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "CloudinaryService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
        }
        
        // Create upload request
        var request = URLRequest(url: URL(string: uploadURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Create multipart form data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add upload preset parameter (for unsigned uploads)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(uploadPreset)\r\n".data(using: .utf8)!)
        
        // Add file data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Close the form
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Execute the request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let responseString = String(data: data, encoding: .utf8) ?? "No response data"
            throw NSError(domain: "CloudinaryService", code: 2,
                          userInfo: [NSLocalizedDescriptionKey: "Upload failed: \(responseString)"])
        }
        
        // Parse the response
        guard let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let secureUrl = jsonResponse["secure_url"] as? String else {
            throw NSError(domain: "CloudinaryService", code: 3,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to get secure URL from response"])
        }
        
        return secureUrl
    }
}

// Extension to help with Data creation for multipart form
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
