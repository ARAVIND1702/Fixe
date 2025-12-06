//
//  ServiceStage.swift
//  Fixe
//
//  Created by MRN7BAN on 19/10/25.
//
import Foundation

struct ServiceStage: Identifiable, Codable {
    var id = UUID()
    let date: String
    let title: String
    let subtitle: String?
    let isCompleted: Bool
}

