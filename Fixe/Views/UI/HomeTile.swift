//
//  HomeTile.swift
//  Fixe
//
//  Created by MRN7BAN on 04/12/25.
//

import SwiftUI

struct HomeTile: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: 10) {
            // Circular icon
            Image(systemName: icon)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .frame(width: 64, height: 64)
                .background(
                    LinearGradient(
                        colors: [Color.hcBlueLight.opacity(0.3), Color.hcBlue.opacity(0.15)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    Circle()
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color.hcBlue, Color.hcBlueLight],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .clipShape(Circle())
                .shadow(color: Color.hcBlue.opacity(0.15), radius: 6, y: 3)
            
            // Label
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(Color.hcTextPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80)
    }
}

#Preview {
    HStack(spacing: 24) {
        HomeTile(icon: "wrench.and.screwdriver.fill", title: "Service")
        HomeTile(icon: "clock.arrow.circlepath", title: "History")
        HomeTile(icon: "washer.fill", title: "Products")
        HomeTile(icon: "tag.fill", title: "Offers")
    }
    .padding()
}
