//
//  UserDefaultsManager.swift
//  petstagram
//
//  Created by Parama Artha on 30/04/25.
//

import Foundation

@MainActor
class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    private let uidKey = "user_uid"
    
    private init() {}
    
    var userUID: String? {
        get {
            return defaults.string(forKey: uidKey)
        }
        set {
            defaults.set(newValue, forKey: uidKey)
        }
    }
    
    func clearUserData() {
        defaults.removeObject(forKey: uidKey)
    }
} 