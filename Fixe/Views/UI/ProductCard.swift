//
//  ProductCard.swift
//  Fixe
//
//  Created by MRN7BAN on 06/12/25.
//

import SwiftUI


struct ProductCard: View {
    let product: Product

    var body: some View {
        VStack(spacing: 12) {
            // Image area
            Image(product.imageName)
                .resizable()
                .scaledToFill()
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)

            // Details container
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemBackground).opacity(0.98))
                .overlay {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(product.title)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            Text(product.brand)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(Color.accentColor.opacity(0.12))
                                .cornerRadius(8)
                        }

                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("E-No.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(product.eNumber)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }

                            Spacer()

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Purchased")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(product.purchaseDate)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding(12)
                }
                .frame(height: 100)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 6)
    }
}
