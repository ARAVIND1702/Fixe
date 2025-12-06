//
//  ChatMessage.swift
//  Fixe
//
//  Created by MRN7BAN on 18/11/25.
//

// ChatMessage.swift
import Foundation

struct ChatMessage: Identifiable, Equatable {
    let id: UUID = UUID()
    let text: String
    let isUser: Bool
    let timestamp: Date

    init(text: String, isUser: Bool, timestamp: Date = Date()) {
        self.text = text
        self.isUser = isUser
        self.timestamp = timestamp
    }
}
