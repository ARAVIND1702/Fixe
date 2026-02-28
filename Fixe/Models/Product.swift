//
//  Product.swift
//  Fixe
//
//  Created by MRN7BAN on 06/12/25.
//

import Foundation



// Simple product model
struct Product: Identifiable {
    let id: UUID = UUID()
    let title: String
    let brand: String
    let eNumber: String
    let purchaseDate: String
    let imageName: String
    let isAssetImage: Bool  // true = asset catalog image, false = SF Symbol
    
    init(title: String, brand: String, eNumber: String, purchaseDate: String, imageName: String, isAssetImage: Bool = false) {
        self.title = title
        self.brand = brand
        self.eNumber = eNumber
        self.purchaseDate = purchaseDate
        self.imageName = imageName
        self.isAssetImage = isAssetImage
    }
}
