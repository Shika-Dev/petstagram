//
//  UserDefaultsManager.swift
//  petstagram
//
//  Created by Parama Artha on 30/04/25.
//

import Foundation

@MainActor
class UserDefaultsManager {
    
    private let defaults = UserDefaults.standard
    private let uidKey = "user_uid"
    private let fullNameKey = "full_name"
    private let bioKey = "bio"
    private let usernameKey = "username"
    private let profilePictureURLKey = "profile_picture_url_string"
    
    init() {}
    
    var userUID: String? {
        get {
            let uid = defaults.string(forKey: uidKey)
            return uid
        }
        set {
            defaults.set(newValue, forKey: uidKey)
            defaults.synchronize() // Force immediate save
        }
    }
    
    var fullName: String? {
        get {
            return defaults.string(forKey: fullNameKey)
        }
        set {
            defaults.set(newValue, forKey: fullNameKey)
        }
    }
    
    var bio: String? {
        get {
            return defaults.string(forKey: bioKey)
        }
        set {
            defaults.set(newValue, forKey: bioKey)
        }
    }
    
    var username: String? {
        get {
            return defaults.string(forKey: usernameKey)
        }
        set {
            defaults.set(newValue, forKey: usernameKey)
        }
    }
    
    var profilePictureUrl: String? {
        get {
            return defaults.string(forKey: profilePictureURLKey)
        }
        set {
            defaults.set(newValue, forKey: profilePictureURLKey)
        }
    }
    
    func clearUserData() {
        defaults.removeObject(forKey: uidKey)
    }
} 
