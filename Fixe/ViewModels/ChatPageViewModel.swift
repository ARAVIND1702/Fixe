//
//  ChatPageViewModel.swift
//  Fixe
//
//  Created by MRN7BAN on 20/09/25.
//

// ChatPageViewModel.swift
import Foundation

@MainActor
class ChatPageViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    @Published var isOrderComplete: Bool = false
    @Published var completedOrder: ServiceOrder?
    
    private let sessionId = UUID().uuidString // Generate unique session per conversation
    private let baseURL = "http://localhost:8080"
    
    init() {
        // Add welcome message
        messages.append(ChatMessage(
            text: "Hi! I'm here to help you schedule your appliance service. What seems to be the problem?",
            isUser: false
        ))
    }
    
    func sendMessage() {
        let userMsg = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userMsg.isEmpty else { return }
        
        // Append user message
        messages.append(ChatMessage(text: userMsg, isUser: true))
        inputText = ""
        
        Task {
            await sendToBackend(text: userMsg)
        }
    }
    
    private func sendToBackend(text: String) async {
        isLoading = true
        
        guard let url = URL(string: "\(baseURL)/processServiceRequest") else {
            await appendBotMessage("❌ Invalid server URL.")
            isLoading = false
            return
        }
        
        let requestBody: [String: Any] = [
            "text": text,
            "sessionId": sessionId
        ]
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            request.timeoutInterval = 30
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Debug: Print raw response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📥 Backend Response: \(jsonString)")
            }
            
            guard let httpResp = response as? HTTPURLResponse else {
                await appendBotMessage("❌ Invalid server response.")
                isLoading = false
                return
            }
            
            guard httpResp.statusCode == 200 else {
                await appendBotMessage("❌ Server error (Status: \(httpResp.statusCode))")
                isLoading = false
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let decoded = try decoder.decode(BotResponse.self, from: data)
            
            await handleBotResponse(decoded)
            
        } catch DecodingError.keyNotFound(let key, let context) {
            print("❌ Decoding Error - Missing key: \(key.stringValue)")
            print("Context: \(context.debugDescription)")
            await appendBotMessage("⚠️ Error parsing server response. Please try again.")
        } catch DecodingError.typeMismatch(let type, let context) {
            print("❌ Decoding Error - Type mismatch: \(type)")
            print("Context: \(context.debugDescription)")
            await appendBotMessage("⚠️ Error parsing server response. Please try again.")
        } catch DecodingError.valueNotFound(let type, let context) {
            print("❌ Decoding Error - Value not found: \(type)")
            print("Context: \(context.debugDescription)")
            await appendBotMessage("⚠️ Error parsing server response. Please try again.")
        } catch {
            print("❌ Network Error: \(error.localizedDescription)")
            await appendBotMessage("⚠️ Connection error: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    @MainActor
    private func handleBotResponse(_ response: BotResponse) {
        // Display the bot's message or question
        let botText = response.nextQuestion ?? response.message
        appendBotMessage(botText)
        
        // Check if order is complete
        if response.type == "complete" {
            isOrderComplete = true
            completedOrder = response.data
            
            // Show service stages summary
            if let stages = response.data?.stages, !stages.isEmpty {
                var stagesSummary = "\n📋 Service Timeline:\n"
                for (index, stage) in stages.enumerated() {
                    let icon = stage.isCompleted ? "✅" : "⏳"
                    stagesSummary += "\n\(icon) \(stage.title)"
                    if ((stage.subtitle?.isEmpty) == nil) {
                        stagesSummary += "\n   \(stage.subtitle)"
                    }
                }
                appendBotMessage(stagesSummary)
            }
            
            // Optionally create the confirmed order
            Task {
                await createConfirmedOrder()
            }
        }
        
        // Debug: Show collected data so far
        if let data = response.data {
            print("📊 Collected Data:")
            print("  - Appliance: \(data.applianceType.isEmpty ? "Not provided" : data.applianceType)")
            print("  - Brand: \(data.brand.isEmpty ? "Not provided" : data.brand)")
            print("  - Problem: \(data.problemDescription.isEmpty ? "Not provided" : data.problemDescription)")
            print("  - Name: \(data.customerName.isEmpty ? "Not provided" : data.customerName)")
            print("  - Phone: \(data.customerPhone.isEmpty ? "Not provided" : data.customerPhone)")
            print("  - Address: \(data.customerAddress.isEmpty ? "Not provided" : data.customerAddress)")
            print("  - Date: \(data.preferredDate.isEmpty ? "Not provided" : data.preferredDate)")
            print("  - Time: \(data.preferredTime.isEmpty ? "Not provided" : data.preferredTime)")
            print("  - Stages: \(data.stages.count)")
        }
    }
    
    private func createConfirmedOrder() async {
        guard let order = completedOrder else { return }
        
        guard let url = URL(string: "\(baseURL)/createConfirmedOrder") else {
            await appendBotMessage("❌ Invalid server URL for order creation.")
            return
        }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(order)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 else {
                await appendBotMessage("❌ Failed to create order.")
                return
            }
            
            if let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let orderId = jsonResponse["orderId"] as? String {
                await appendBotMessage("✅ Your service order has been created! Order ID: \(orderId)")
                await appendBotMessage("A technician will contact you shortly. Thank you for choosing Fixe! 🔧")
            }
            
        } catch {
            print("❌ Order Creation Error: \(error.localizedDescription)")
            await appendBotMessage("⚠️ Error creating order: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    private func appendBotMessage(_ text: String) {
        messages.append(ChatMessage(text: text, isUser: false))
    }
    
    func resetConversation() {
        messages.removeAll()
        isOrderComplete = false
        completedOrder = nil
        
        messages.append(ChatMessage(
            text: "Hi! I'm here to help you schedule your appliance service. What seems to be the problem?",
            isUser: false
        ))
    }
}
