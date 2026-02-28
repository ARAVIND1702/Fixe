//
//  LoginpageViewModel.swift
//  Fixe
//
//  Created by MRN7BAN on 19/09/25.
//

import Foundation
import Combine

final class LoginPageViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?

    func login() {
        // Simple validation example
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both username and password"
            return
        }

        // Replace with real authentication logic
        if username == "test" && password == "1234" {
            SessionManager.shared.login(username: username)
            isLoggedIn = true
            errorMessage = nil
        } else {
            isLoggedIn = false
            errorMessage = "Invalid credentials"
        }
    }
    
    func loginAsGuest() {
        SessionManager.shared.loginAsGuest()
        isLoggedIn = true
    }

    func logout() {
        username = ""
        password = ""
        isLoggedIn = false
        SessionManager.shared.logout()
    }
}
