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
                LinearGradient(
                    colors: [
//                        Color.accentColor.opacity(0.15),
                        Color(.systemBackground)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    Spacer(minLength: 40)
                    
                    Image(systemName: "wrench.adjustable.fill")
                        .font(.system(size: 74)) // Increase icon size
                        .foregroundColor(.white) // Icon color
                        .padding(12) // Space around icon
                        .background(
                            LinearGradient(
                                colors: [
                                    Color.accentColor.opacity(0.95),
                                    Color.accentColor.opacity(0.75)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .cornerRadius(24) // Rounded background
                        )
                        .shadow(radius: 2)

                    // MARK: - Logo / Title
                    VStack(spacing: 6) {
                        Text("Fixe")
                            .font(.system(size: 42, weight: .bold))
                            .tracking(4)
                            .foregroundStyle(Color.accentColor)
                        
                        Text("B/S/H/")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                    }
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 24)
                    
                    // MARK: - Card
                    VStack(spacing: 20) {
                        
                        // MARK: - Input Fields
                        VStack(spacing: 14) {
                            // Username
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundStyle(.secondary)
                                TextField("Username", text: $viewModel.username)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled(true)
                            }
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(14)
                            
                            // Password
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundStyle(.secondary)
                                SecureField("Password", text: $viewModel.password)
                            }
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(14)
                        }
                        
                        // MARK: - Login Button
                        Button(action: {
                            viewModel.login()
                        }) {
                            Text("Login")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.accentColor)
                                )
                                .foregroundStyle(.white)
                                .shadow(radius: 4, y: 2)
                        }
                        .buttonStyle(.plain)
                        
                        // MARK: - Continue Without Login
                        NavigationLink(destination: TabPageView(), isActive: $navigateToHome) {
                            Button(action: {
                                navigateToHome = true
                            }) {
                                Text("Quick Fix")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.accentColor.opacity(0.08))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.accentColor.opacity(0.8), lineWidth: 1.2)
                                    )
                                    .foregroundStyle(Color.accentColor)
                            }
                            .buttonStyle(.plain)
                            .padding(.top, 4)
                        }
                        
                       
                        
                    }
                    .padding(22)
                    
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
                .padding(.bottom, 20)
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
