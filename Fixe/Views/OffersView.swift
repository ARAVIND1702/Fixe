//
//  OffersView.swift
//  Fixe
//
//  Created by MRN7BAN on 25/02/26.
//

import SwiftUI

struct OffersView: View {
    
    private let offersURL = "https://www.bosch-home.in/en/category/cleaningcare"
    
    var body: some View {
        VStack(spacing: 0) {
            if let url = URL(string: offersURL) {
                WebView(url: url)
                    .ignoresSafeArea(edges: .bottom)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    Text("Unable to load offers.")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Offers")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    NavigationStack {
        OffersView()
    }
}
