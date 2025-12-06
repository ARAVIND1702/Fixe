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
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().standardAppearance.shadowColor = UIColor.black
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                HomePageView()
                    .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            NavigationStack {
                ChatPageView()
                    .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "bubble")
                Text("Chat")
            }
            
            NavigationStack {
                Text("Settings")
                    .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "gearshape")
                Text("Settings")
            }
        }
    }
}

#Preview {
    TabPageView()
}
