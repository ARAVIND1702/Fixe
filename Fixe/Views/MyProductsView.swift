//
//  MyProductsView.swift
//  Fixe
//
//  Created by MRN7BAN on 16/10/25.
//

import SwiftUI

struct MyProductsView: View {
    @StateObject private var viewModel = MyProductsViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.products.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "shippingbox")
                            .font(.system(size: 48))
                            .foregroundStyle(Color.hcTextSecondary)
                        Text("No products registered yet.")
                            .foregroundColor(Color.hcTextSecondary)
                    }
                    .padding(.top, 80)
                } else {
                    ForEach(viewModel.products) { product in
                        ProductListCard(product: product)
                    }
                }
            }
            .padding()
        }
        .background(Color.hcBackground)
        .navigationTitle("My Products")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

// MARK: - Product Card (Vertical: Image on top, details below)
struct ProductListCard: View {
    let product: Product
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Large Image Area
            if product.isAssetImage {
                Image(product.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .padding(.vertical, 20)
                    .background(Color.hcBlue.opacity(0.06))
            } else {
                Image(systemName: product.imageName)
                    .font(.system(size: 64))
                    .foregroundStyle(Color.hcBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .padding(.vertical, 20)
                    .background(Color.hcBlue.opacity(0.06))
            }
            
            // MARK: - Details Area
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(product.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.hcTextPrimary)
                    Spacer()
                    Text(product.brand)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color.hcBlue)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .background(Color.hcBlue.opacity(0.1))
                        .cornerRadius(8)
                }
                
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("E-Number")
                            .font(.caption)
                            .foregroundColor(Color.hcTextSecondary)
                        Text(product.eNumber)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.hcTextPrimary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Purchased")
                            .font(.caption)
                            .foregroundColor(Color.hcTextSecondary)
                        Text(product.purchaseDate)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.hcTextPrimary)
                    }
                }
            }
            .padding(16)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 8, y: 3)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    NavigationStack {
        MyProductsView()
    }
}
