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
        serviceType: "Repair",
        preferredDate: "",
        preferredTime: "",
        customerName: "",
        customerPhone: "",
        customerAddress: "",
        status: "pending",
        urgency: nil
    )
    
    @Published var savedOrders: [ServiceOrder] = []
    
    // MARK: - Slot-based scheduling
    @Published var selectedDay: Date = Date()
    @Published var selectedSlot: TimeSlot? = nil
    
    /// Generate available time slots for a given day (Outlook-style)
    func availableSlots(for date: Date) -> [TimeSlot] {
        let calendar = Calendar.current
        let isToday = calendar.isDateInToday(date)
        let currentHour = calendar.component(.hour, from: Date())
        
        // Slots from 9 AM to 6 PM, 1-hour blocks
        let slotDefinitions: [(start: Int, end: Int)] = [
            (9, 10), (10, 11), (11, 12),
            (12, 13), (13, 14), (14, 15),
            (15, 16), (16, 17), (17, 18)
        ]
        
        return slotDefinitions.compactMap { slot in
            // Skip past slots if today
            if isToday && slot.start <= currentHour {
                return nil
            }
            
            let startTime = formatHour(slot.start)
            let endTime = formatHour(slot.end)
            
            return TimeSlot(
                id: "\(slot.start)-\(slot.end)",
                startHour: slot.start,
                endHour: slot.end,
                label: "\(startTime) – \(endTime)",
                isAvailable: true
            )
        }
    }
    
    /// Get the next 7 days for day selection
    var availableDays: [Date] {
        let calendar = Calendar.current
        return (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: Date())
        }
    }
    
    private func formatHour(_ hour: Int) -> String {
        let period = hour >= 12 ? "PM" : "AM"
        let displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour)
        return "\(displayHour):00 \(period)"
    }
    
    /// Update the order's preferred date and time from the selected slot
    func applySelectedSlot() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        order.preferredDate = dateFormatter.string(from: selectedDay)
        
        if let slot = selectedSlot {
            order.preferredTime = slot.label
        }
    }
    
    func initializeServiceStages() {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = dateFormatter.string(from: now)
        
        let subtitle = order.serviceType == "General Checkup"
            ? "General Checkup"
            : order.problemDescription
        
        let stage = ServiceStage(
            date: dateString,
            title: "Case Registered",
            subtitle: subtitle,
            isCompleted: false
        )
        order.stages = [stage]
    }
    
    func isFormValid() -> Bool {
        let baseValid = !order.applianceType.isEmpty &&
               !order.brand.isEmpty &&
               !order.customerName.isEmpty &&
               !order.customerPhone.isEmpty &&
               !order.customerAddress.isEmpty &&
               selectedSlot != nil
        
        if order.serviceType == "Repair" {
            return baseValid && !order.problemDescription.isEmpty
        }
        return baseValid
    }
    
    func saveToHistory() async -> Bool {
        applySelectedSlot()
        return await submitOrderToFirebase()
    }
    
    func submitOrderToFirebase() async -> Bool {
        let firebaseService = FirebaseService()
        let userId = SessionManager.shared.userId
        
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
        order.serviceType = "Repair"
        order.urgency = nil
        selectedSlot = nil
        selectedDay = Date()
    }
}

// MARK: - TimeSlot Model
struct TimeSlot: Identifiable, Equatable {
    let id: String
    let startHour: Int
    let endHour: Int
    let label: String
    let isAvailable: Bool
}
