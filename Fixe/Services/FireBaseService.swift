//
//  FireBaseService.swift
//  Fixe
//
//  Created by MRN7BAN on 19/10/25.
//

import Foundation
import FirebaseDatabaseInternal

class FirebaseService {
    
    private let dbRef = Database.database().reference()  // Root reference
    
    /// Save a service order to Firebase Realtime Database
    func saveServiceOrder(_ order: ServiceOrder, completion: @escaping (Bool) -> Void) {
        // Create a unique ID for order
        let orderId = UUID().uuidString
        let orderRef = dbRef.child("serviceOrders").child(orderId)
        
        // Convert model to dictionary for Firebase
        let orderData: [String: Any] = [
            "id": orderId,
            "applianceType": order.applianceType,
            "brand": order.brand,
            "eNumber": order.eNumber,
            "problemDescription": order.problemDescription,
            "serviceType": order.serviceType,
            "preferredDate": order.preferredDate,
            "preferredTime": order.preferredTime,
            "customerName": order.customerName,
            "customerPhone": order.customerPhone,
            "customerAddress": order.customerAddress,
            "status": order.status ?? "Pending",
            "urgency": order.urgency ?? "medium"
        ]
        
        // Save to Firebase
        orderRef.setValue(orderData) { error, _ in
            if let error = error {
                print("❌ Firebase Save Error: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ Order Saved Successfully to Firebase")
                completion(true)
            }
        }
    }
    
    /// Append order to user's order list in Firebase
        func addOrderForUser(userId: String, order: ServiceOrder, completion: @escaping (Bool) -> Void) {
            
            let userOrdersRef = dbRef.child("users").child(userId).child("orders")
            
            // Fetch existing orders and append
            userOrdersRef.observeSingleEvent(of: .value) { snapshot in
                
                var ordersArray: [[String: Any]] = []
                
                // If existing orders found, load them to array
                if let existingArray = snapshot.value as? [[String: Any]] {
                    ordersArray = existingArray
                }
                
                // Convert new order to dictionary
                let orderData: [String: Any] = [
                    "id": UUID().uuidString,
                    "applianceType": order.applianceType,
                    "brand": order.brand,
                    "eNumber": order.eNumber,
                    "problemDescription": order.problemDescription,
                    "serviceType": order.serviceType,
                    "preferredDate": order.preferredDate,
                    "preferredTime": order.preferredTime,
                    "customerName": order.customerName,
                    "customerPhone": order.customerPhone,
                    "customerAddress": order.customerAddress,
                    "status": order.status ?? "Pending",
                    "urgency": order.urgency ?? "medium",
                    "stages": order.stages.map { stage in
                           [
                               "id": stage.id.uuidString,
                               "date": stage.date,
                               "title": stage.title,
                               "subtitle": stage.subtitle ?? "",
                               "isCompleted": stage.isCompleted
                           ]
                       }
                ]
                
                // Append new order to array
                ordersArray.append(orderData)
                
                // Save updated array back to Firebase
                userOrdersRef.setValue(ordersArray) { error, _ in
                    if let error = error {
                        print("❌ Firebase Save Error: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("✅ Order Appended to User History")
                        completion(true)
                    }
                }
            }
        }
    
    // 🔽 Fetch Orders for a User
        func fetchOrdersForUser(userId: String, completion: @escaping ([ServiceOrder]) -> Void) {
            let userOrdersRef = dbRef.child("users").child(userId).child("orders")
            
            userOrdersRef.observeSingleEvent(of: .value) { snapshot in
                var fetchedOrders: [ServiceOrder] = []
                
                // Extract Firebase array
                if let arrayData = snapshot.value as? [[String: Any]] {
                    for data in arrayData {
                        if let order = self.mapToOrder(data: data) {
                            fetchedOrders.append(order)
                        }
                    }
                }
                
                completion(fetchedOrders)
            }
        }
        
        // 🔁 Helper to convert Firebase dictionary → ServiceOrder model
        private func mapToOrder(data: [String: Any]) -> ServiceOrder? {
            let stageArray = (data["stages"] as? [[String: Any]])?.compactMap { stageDict in
                    ServiceStage(
                        date: stageDict["date"] as? String ?? "",
                        title: stageDict["title"] as? String ?? "",
                        subtitle: stageDict["subtitle"] as? String ?? nil,
                        isCompleted: stageDict["isCompleted"] as? Bool ?? false
                    )
                } ?? []

                return ServiceOrder(
                    id: data["id"] as? String ?? UUID().uuidString,
                    applianceType: data["applianceType"] as? String ?? "",
                    brand: data["brand"] as? String ?? "",
                    eNumber: data["eNumber"] as? String ?? "",
                    problemDescription: data["problemDescription"] as? String ?? "",
                    serviceType: data["serviceType"] as? String ?? "repair",
                    preferredDate: data["preferredDate"] as? String ?? "",
                    preferredTime: data["preferredTime"] as? String ?? "",
                    customerName: data["customerName"] as? String ?? "",
                    customerPhone: data["customerPhone"] as? String ?? "",
                    customerAddress: data["customerAddress"] as? String ?? "",
                    status: data["status"] as? String ?? "Pending",
                    urgency: data["urgency"] as? String ?? "medium",
                    stages: stageArray
                )
        }
}
