//
//  Color+Theme.swift
//  Fixe
//
//  Created by MRN7BAN on 16/10/25.
//
import SwiftUI

extension Color {
    static let primaryColor = Color("AppPrimary")
    static let secondaryColor = Color("AppSecondary")
    
    // Home Connect Blue palette
    static let hcBlue = Color(red: 0.098, green: 0.463, blue: 0.824)       // #1976D2
    static let hcBlueLight = Color(red: 0.392, green: 0.710, blue: 0.965)   // #64B5F6
    static let hcBlueDeep = Color(red: 0.051, green: 0.278, blue: 0.631)    // #0D47A1
    static let hcBackground = Color(red: 0.961, green: 0.969, blue: 0.980)  // #F5F7FA
    static let hcTextPrimary = Color(red: 0.102, green: 0.102, blue: 0.180) // #1A1A2E
    static let hcTextSecondary = Color(red: 0.420, green: 0.451, blue: 0.498) // #6B7280
    
    // Blue gradient for buttons/headers
    static let hcGradient = LinearGradient(
        colors: [Color.hcBlue, Color.hcBlueLight],
        startPoint: .leading,
        endPoint: .trailing
    )
}
