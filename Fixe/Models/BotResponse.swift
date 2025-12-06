//
//  BotResponse.swift
//  Fixe
//
//  Created by MRN7BAN on 18/11/25.
//

struct BotResponse: Codable {
    let type: String
    let message: String
    let missingField: String?
    let nextQuestion: String?
    let data: ServiceOrder?
    
    enum CodingKeys: String, CodingKey {
        case type
        case message
        case missingField
        case nextQuestion
        case data
    }
}
