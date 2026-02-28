//
//  SettingsView.swift
//  Fixe
//
//  Created by MRN7BAN on 24/02/26.
//

import SwiftUI

struct SettingsPageView: View {
    @State private var showSignInSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                // MARK: - Header
                HStack {
                    Text("Settings")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(Color.hcTextPrimary)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "bell")
                            .font(.title3)
                            .foregroundStyle(Color.hcBlue)
                            .frame(width: 40, height: 40)
                            .background(Color.hcBlue.opacity(0.08))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)
                
                // MARK: - Sign In Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Let's get started")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.hcTextPrimary)
                    
                    Text("Start with Fixe and sign in now!")
                        .font(.subheadline)
                        .foregroundStyle(Color.hcTextSecondary)
                    
                    Button(action: {
                        showSignInSheet = true
                    }) {
                        Text("Sign in")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: [Color.hcBlue, Color.hcBlueLight],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
                
                // MARK: - Works with Fixe
                SettingsSectionHeader(title: "Works with Fixe")
                SettingsRow(icon: "apps.iphone", title: "Apps & services")
                SettingsDivider()
                
                // MARK: - My Preferences
                SettingsSectionHeader(title: "My preferences")
                SettingsRow(icon: "bell.badge", title: "Notification settings")
                SettingsDivider()
                
                // MARK: - Privacy & Legal
                VStack(spacing: 0) {
                    SettingsSectionHeader(title: "Privacy & legal")
                    SettingsRow(icon: nil, title: "App usage")
                    SeparatorLine()
                    SettingsRow(icon: nil, title: "Legal information")
                }
                .background(Color.hcBackground)
                
                SettingsDivider()
                
                // MARK: - Fixe
                SettingsSectionHeader(title: "Fixe")
                SettingsRow(icon: "questionmark.circle.fill", iconColor: Color.hcBlue, title: "Support & information")
                
                Spacer(minLength: 40)
            }
        }
        .background(Color.white)
        .sheet(isPresented: $showSignInSheet) {
            NavigationStack {
                WebView(url: URL(string: "https://www.home-connect.com/gb/en/help-support/singlekey-id")!)
                    .ignoresSafeArea(edges: .bottom)
                    .navigationTitle("Sign In")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Close") {
                                showSignInSheet = false
                            }
                            .foregroundStyle(Color.hcBlue)
                        }
                    }
            }
        }
    }
}

// MARK: - Section Header
struct SettingsSectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(Color.hcTextPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 12)
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    var icon: String? = nil
    var iconColor: Color = Color.hcTextSecondary
    let title: String
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.body)
                        .foregroundStyle(iconColor)
                        .frame(width: 28)
                }
                
                Text(title)
                    .font(.body)
                    .foregroundStyle(Color.hcTextPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.hcTextSecondary.opacity(0.5))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
        }
    }
}

// MARK: - Separator Line
struct SeparatorLine: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.15))
            .frame(height: 0.5)
            .padding(.horizontal, 20)
    }
}

// MARK: - Section Divider
struct SettingsDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.hcBackground)
            .frame(height: 8)
    }
}

#Preview {
    SettingsPageView()
}
