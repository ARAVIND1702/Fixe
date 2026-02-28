//
//  Constans.swift
//  Fixe
//
//  Created by MRN7BAN on 18/10/25.
//
import Foundation

struct Constants {    
    struct ServiceDataProvider {
        static let applianceTypes = ["Refrigerators", "Dishwashers", "Washers", "Dryers"]
        static let brands = ["Bosch", "Siemens"]
        static let serviceTypes = ["Repair", "General Checkup"]
    }
    
    struct ChatBackend {
        static let baseURL = "http://localhost:8080"
    }
}
