//
//  MyProductsViewModel.swift
//  Fixe
//
//  Created by MRN7BAN on 16/10/25.
//
import Foundation

class MyProductsViewModel: ObservableObject {
    
    @Published var products: [Product] = [
        Product(
            title: "Washing Machine",
            brand: "Bosch",
            eNumber: "WAJ2846SIN",
            purchaseDate: "15 Mar 2024",
            imageName: "WashingMachine",
            isAssetImage: true
        ),
        Product(
            title: "Dishwasher",
            brand: "Siemens",
            eNumber: "SN658X03JE",
            purchaseDate: "22 Jun 2023",
            imageName: "dishwasher.fill"
        ),
        Product(
            title: "Refrigerator",
            brand: "Bosch",
            eNumber: "KGN56XI40I",
            purchaseDate: "10 Jan 2024",
            imageName: "refrigerator.fill"
        ),
        Product(
            title: "Dryer",
            brand: "Siemens",
            eNumber: "WT46G402IN",
            purchaseDate: "05 Aug 2023",
            imageName: "dryer.fill"
        )
    ]
}
