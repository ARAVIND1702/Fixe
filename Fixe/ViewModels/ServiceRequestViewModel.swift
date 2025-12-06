//
//  ServiceRequestViewModel.swift
//  Fixe
//
//  Created by MRN7BAN on 12/10/25.
//
import Foundation

class ServiceRequestViewModel: ObservableObject {
    
    @Published var order = ServiceOrder(
        applianceType: "",
        brand: "",
        eNumber: "",
        problemDescription: "",
        serviceType: "repair",
        preferredDate: "",
        preferredTime: "",
        customerName: "",
        customerPhone: "",
        customerAddress: "",
        status: "pending",
        urgency: "medium",
        stages: []
    )
    
    @Published var savedOrders: [ServiceOrder] = []
    

    
   var selectedDate: Date = Date(){
       didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            order.preferredDate = dateFormatter.string(from: selectedDate)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            order.preferredTime = timeFormatter.string(from: selectedDate)
        }
    }
    
    func initializeServiceStages() {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // or customize format if needed
        let dateString = dateFormatter.string(from: now)
        
        let stage = ServiceStage(
            date: dateString,
            title: "Case Registered",
            subtitle: order.problemDescription,
            isCompleted: false
        )
        order.stages = [stage]
//        order.stages = [
//            ServiceStage(date: "21/07/2023 09:40", title: "Case Registered", subtitle: "Issue - Beeping Sound", isCompleted: true),
//            ServiceStage(date: "22/07/2023 10:40", title: "Allocated", subtitle: "Delhi NCR Branch", isCompleted: true),
//            ServiceStage(date: "22/07/2023 01:40", title: "Engineer Assigned", subtitle: "Mohan Singh", isCompleted: true),
//            ServiceStage(date: "22/07/2023 04:00", title: "OTP Received", subtitle: "3 4 3 2", isCompleted: true),
//            ServiceStage(date: "23/07/2023 09:40", title: "Case Closed", subtitle: nil, isCompleted: true)
//        ]
    }

    
//    func submitOrder() async -> Bool {
//        guard let url = URL(string: "http://localhost:8080/createConfirmedOrder") else { return false }
//        
//        do {
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            
//            let jsonData = try JSONEncoder().encode(order)
//            request.httpBody = jsonData
//            
//            let (_, response) = try await URLSession.shared.data(for: request)
//            
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                return true
//            }
//        } catch {
//            print("Error submitting order:", error)
//        }
//        return false
//    }
    
    func isFormValid() -> Bool {
        return !order.applianceType.isEmpty &&
               !order.brand.isEmpty &&
               !order.problemDescription.isEmpty &&
               !order.customerName.isEmpty &&
        !order.customerPhone.isEmpty &&
               !order.customerAddress.isEmpty &&
               !order.preferredDate.isEmpty &&
               !order.preferredTime.isEmpty
    }
    

    func saveToHistory() async -> Bool {
        return await submitOrderToFirebase()
    }
    
    func submitOrderToFirebase() async -> Bool {
        let firebaseService = FirebaseService()
        let userId = "User123" // Use actual userId (from Auth or locally)
        
        return await withCheckedContinuation { continuation in
            firebaseService.addOrderForUser(userId: userId, order: order) { success in
                if success {
                    print("Order successfully added to history!")
                    self.resetForm()
                }
                continuation.resume(returning: success)
            }
        }
    }
    
    func resetForm() {
        order.applianceType = ""
        order.brand = ""
        order.problemDescription = ""
        order.customerName = ""
        order.customerPhone = ""
        order.customerAddress = ""
        order.preferredDate = ""
        order.preferredTime = ""
        order.eNumber = ""
        order.serviceType = ""
        order.urgency = ""
    }
    
    
}
