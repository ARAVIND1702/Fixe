import Foundation

@MainActor
class ChatPageViewModel: ObservableObject {

    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    @Published var isOrderComplete: Bool = false
    @Published var completedOrder: ServiceOrder?

    private let sessionId = UUID().uuidString
    private let baseURL = Constants.ChatBackend.baseURL

    init() {
        messages.append(
            ChatMessage(
                text: "Hi! I'm here to help you schedule your appliance service. What seems to be the problem?",
                isUser: false
            )
        )
        print("🆔 Session ID:", sessionId)
    }

    func sendMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        messages.append(ChatMessage(text: trimmed, isUser: true))
        inputText = ""

        Task { await sendToBackend(text: trimmed) }
    }

    private func sendToBackend(text: String) async {
        isLoading = true

        guard let url = URL(string: "\(baseURL)/processServiceRequest") else {
            appendBot("❌ Invalid server URL")
            isLoading = false
            return
        }

        let payload: [String: Any] = [
            "text": text,
            "sessionId": sessionId
        ]

        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)

            let (data, response) = try await URLSession.shared.data(for: request)

            print("📥 RAW RESPONSE:")
            print(String(data: data, encoding: .utf8) ?? "nil")

            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                appendBot("❌ Server error")
                isLoading = false
                return
            }

            // ✅ SIMPLE decoder (NO snake_case)
            let decoded = try JSONDecoder().decode(BotResponse.self, from: data)
            handleBotResponse(decoded)

        } catch {
            print("❌ Decode / Network error:", error)
            appendBot("⚠️ Error parsing server response. Please try again.")
        }

        isLoading = false
    }

    private func handleBotResponse(_ response: BotResponse) {
        appendBot(response.nextQuestion ?? response.message)

        if response.type == "complete" {
            isOrderComplete = true
            completedOrder = response.data

            Task { await createConfirmedOrder() }
        }

        if let data = response.data {
            print("📊 DATA COLLECTED")
            print("Appliance:", data.applianceType)
            print("Brand:", data.brand)
            print("Problem:", data.problemDescription)
            print("Name:", data.customerName)
            print("Phone:", data.customerPhone)
            print("Address:", data.customerAddress)
            print("Date:", data.preferredDate)
            print("Time:", data.preferredTime)
        }
    }

    private func createConfirmedOrder() async {
        guard let order = completedOrder,
              let url = URL(string: "\(baseURL)/createConfirmedOrder") else { return }

        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(order)

            let (data, _) = try await URLSession.shared.data(for: request)

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let orderId = json["orderId"] as? String {
                appendBot("✅ Your service order has been created!")
                appendBot("🆔 Order ID: \(orderId)")
                appendBot("A technician will contact you shortly 🔧")
            }
        } catch {
            appendBot("⚠️ Failed to create order.")
        }
    }

    private func appendBot(_ text: String) {
        messages.append(ChatMessage(text: text, isUser: false))
    }

    func resetConversation() {
        messages.removeAll()
        isOrderComplete = false
        completedOrder = nil

        messages.append(
            ChatMessage(
                text: "Hi! I'm here to help you schedule your appliance service. What seems to be the problem?",
                isUser: false
            )
        )
    }
}
