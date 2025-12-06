//
//  ServiceOrder.swift
//  Fixe
//
//  Created by MRN7BAN on 20/09/25.
//
import Foundation

struct ServiceOrder: Identifiable, Codable {
    var id: String = UUID().uuidString     
    var applianceType: String
    var brand: String
    var eNumber: String
    var problemDescription: String
    var serviceType: String
    var preferredDate: String
    var preferredTime: String
    var customerName: String
    var customerPhone: String
    var customerAddress: String
    var status: String? = "Pending"
    var urgency: String?
    var stages: [ServiceStage] = []
}

var stages: [ServiceStage] = [
    ServiceStage(date: "21/07/2023 09:40", title: "Case Registered", subtitle: "Issue - Beeping Sound", isCompleted: true),
    ServiceStage(date: "22/07/2023 10:40", title: "Allocated", subtitle: "Delhi NCR Branch", isCompleted: true),
    ServiceStage(date: "22/07/2023 01:40", title: "Engineer Assigned", subtitle: "Mohan Singh", isCompleted: true),
    ServiceStage(date: "22/07/2023 04:00", title: "OTP Received", subtitle: "3 4 3 2", isCompleted: true),
    ServiceStage(date: "23/07/2023 09:40", title: "Case Closed", subtitle: nil, isCompleted: true)
]

var applianceTypes = ["Refrigerators","Dishwashers","Washers & Dryers"]
var brands = ["Bosch","Siemens"]
var serviceTypes = ["Genral","Repair"]
var urgency = ["High","Moderate","Low"]
var status = ["Closed","Pending","Hold"]


