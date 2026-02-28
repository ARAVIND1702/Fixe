//
//  TabPageView.swift
//  Fixe
//
//  Created by MRN7BAN on 20/09/25.
//

import SwiftUI

struct TabPageView: View {
    @State var selectedTab = 0
    
    init() {
        // HC-style clean white tab bar
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.08)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                HomePageView()
                    .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "homekit")
                Text("Home")
            }
            
            NavigationStack {
                ChatPageView()
                    .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "bubble.left.and.bubble.right")
                Text("Chat")
            }
            
            NavigationStack {
                SettingsPageView()
                    .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "gearshape")
                Text("Settings")
            }
        }
        .tint(Color.hcBlue)
    }
}

#Preview {
    TabPageView()
}
