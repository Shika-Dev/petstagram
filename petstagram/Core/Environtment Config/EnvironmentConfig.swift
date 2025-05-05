//
//  EnvironmentConfig.swift
//  petstagram
//
//  Created by Parama Artha on 05/05/25.
//


import Foundation

enum EnvironmentConfig {
    // MARK: - Environment Variables
    
    // Create an enum for all app environment variables
    enum Keys: String {
        // Cloudinary credentials
        case cloudinaryCloudName = "CLOUDINARY_CLOUD_NAME"
        case cloudinaryApiKey = "CLOUDINARY_API_KEY"
        case cloudinaryApiSecret = "CLOUDINARY_API_SECRET"
        case cloudinaryUploadPreset = "CLOUDINARY_UPLOAD_PRESET"
        
        // Add other environment variables as needed
    }
    
    // MARK: - Retrieval Methods
    
    /// Get environment variable from Info.plist
    static func value(for key: Keys) -> String {
        guard let value = Bundle.main.infoDictionary?[key.rawValue] as? String else {
            #if DEBUG
            fatalError("Missing environment variable: \(key.rawValue)")
            #else
            print("⚠️ Missing environment variable: \(key.rawValue)")
            return ""
            #endif
        }
        return value
    }
    
    // Convenience getters for specific values
    static var cloudinaryCloudName: String {
        return value(for: .cloudinaryCloudName)
    }
    
    static var cloudinaryApiKey: String {
        return value(for: .cloudinaryApiKey)
    }
    
    static var cloudinaryApiSecret: String {
        return value(for: .cloudinaryApiSecret)
    }
    
    static var cloudinaryUploadPreset: String {
        return value(for: .cloudinaryUploadPreset)
    }
}
