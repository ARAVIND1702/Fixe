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
            Image(systemName: icon)
                .font(.title)
                .fontWeight(.light)
                .foregroundStyle(Color.black)
                .padding()
                .background { Circle().fill(Color.white) }
            
            Text(title)
                .font(.title3)
                .kerning(0.5)
                .fontWeight(.medium)
                .foregroundStyle(Color.secondaryColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.accentColor.opacity(0.9))
        )
    }
}
