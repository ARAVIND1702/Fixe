//
//  SessionManager.swift
//  Fixe
//
//  Created by MRN7BAN on 24/02/26.
//

import Foundation

class SessionManager: ObservableObject {
    static let shared = SessionManager()
    
    private let userIdKey = "fixe_userId"
    private let usernameKey = "fixe_username"
    private let isLoggedInKey = "fixe_isLoggedIn"
    
    @Published var userId: String
    @Published var username: String
    @Published var isLoggedIn: Bool
    
    private init() {
        let storedUserId = UserDefaults.standard.string(forKey: userIdKey)
        let storedUsername = UserDefaults.standard.string(forKey: usernameKey)
        let storedIsLoggedIn = UserDefaults.standard.bool(forKey: isLoggedInKey)
        
        if storedIsLoggedIn, let userId = storedUserId, let username = storedUsername {
            self.userId = userId
            self.username = username
            self.isLoggedIn = true
        } else {
            // Auto-initialize as guest since there is no login page
            let guestId = "Guest_\(UUID().uuidString.prefix(8))"
            self.userId = guestId
            self.username = "Guest"
            self.isLoggedIn = true
            
            UserDefaults.standard.set(guestId, forKey: userIdKey)
            UserDefaults.standard.set("Guest", forKey: usernameKey)
            UserDefaults.standard.set(true, forKey: isLoggedInKey)
        }
    }
    
    /// Login with credentials
    func login(username: String) {
        let userId = "User_\(username)"
        self.userId = userId
        self.username = username
        self.isLoggedIn = true
        
        UserDefaults.standard.set(userId, forKey: userIdKey)
        UserDefaults.standard.set(username, forKey: usernameKey)
        UserDefaults.standard.set(true, forKey: isLoggedInKey)
    }
    
    /// Guest login
    func loginAsGuest() {
        let guestId = "Guest_\(UUID().uuidString.prefix(8))"
        self.userId = guestId
        self.username = "Guest"
        self.isLoggedIn = true
        
        UserDefaults.standard.set(guestId, forKey: userIdKey)
        UserDefaults.standard.set("Guest", forKey: usernameKey)
        UserDefaults.standard.set(true, forKey: isLoggedInKey)
    }
    
    /// Logout and clear session
    func logout() {
        self.userId = ""
        self.username = ""
        self.isLoggedIn = false
        
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.removeObject(forKey: usernameKey)
        UserDefaults.standard.set(false, forKey: isLoggedInKey)
    }
}
