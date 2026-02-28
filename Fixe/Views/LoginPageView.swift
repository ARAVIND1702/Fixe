//
//  LoginPageView.swift
//  Fixe
//
//  Created by MRN7BAN on 19/09/25.
//


import SwiftUI

struct LoginPageView: View {
    @StateObject private var viewModel = LoginPageViewModel()
    @State private var navigateToHome = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Background
                Color.hcBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // MARK: - Blue Gradient Hero
                    ZStack {
                        LinearGradient(
                            colors: [Color.hcBlueDeep, Color.hcBlue, Color.hcBlueLight],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        
                        // Subtle cloud/circle decorations
                        Circle()
                            .fill(Color.white.opacity(0.08))
                            .frame(width: 200, height: 200)
                            .offset(x: -100, y: -40)
                        
                        Circle()
                            .fill(Color.white.opacity(0.05))
                            .frame(width: 300, height: 300)
                            .offset(x: 120, y: 20)
                        
                        VStack(spacing: 8) {
                            Image(systemName: "wrench.adjustable.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.white.opacity(0.9))
                            
                            Text("Fixe")
                                .font(.system(size: 38, weight: .bold))
                                .tracking(3)
                                .foregroundStyle(.white)
                            
                            Text("B/S/H/")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.7))
                            
                            Text("Hello,\nlet's get started!")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .padding(.top, 8)
                        }
                    }
                    .frame(height: 300)
                    .clipShape(
                        RoundedCorner(radius: 32, corners: [.bottomLeft, .bottomRight])
                    )
                    
                    // MARK: - Card
                    VStack(spacing: 20) {
                        
                        // MARK: - Input Fields
                        VStack(spacing: 14) {
                            // Username
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundStyle(Color.hcTextSecondary)
                                    .frame(width: 20)
                                TextField("Username", text: $viewModel.username)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled(true)
                            }
                            .padding(14)
                            .background(Color.hcBackground)
                            .cornerRadius(12)
                            
                            // Password
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundStyle(Color.hcTextSecondary)
                                    .frame(width: 20)
                                SecureField("Password", text: $viewModel.password)
                            }
                            .padding(14)
                            .background(Color.hcBackground)
                            .cornerRadius(12)
                        }
                        
                        // MARK: - Login Button
                        Button(action: {
                            viewModel.login()
                            if viewModel.isLoggedIn {
                                navigateToHome = true
                            }
                        }) {
                            Text("Login")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        colors: [Color.hcBlue, Color.hcBlueLight],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .cornerRadius(14)
                                )
                                .foregroundStyle(.white)
                                .shadow(color: Color.hcBlue.opacity(0.3), radius: 8, y: 4)
                        }
                        .buttonStyle(.plain)
                        
                        // MARK: - Continue Without Login
                        NavigationLink(destination: TabPageView(), isActive: $navigateToHome) {
                            Button(action: {
                                viewModel.loginAsGuest()
                                navigateToHome = true
                            }) {
                                Text("Quick Fix")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Color.hcBlue.opacity(0.08))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.hcBlue.opacity(0.4), lineWidth: 1.2)
                                    )
                                    .foregroundStyle(Color.hcBlue)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(24)
                    .padding(.top, 8)
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden()
            .ignoresSafeArea(.keyboard)
        }
    }
}

#Preview {
    NavigationStack {
        LoginPageView()
            .preferredColorScheme(.light)
    }
}
