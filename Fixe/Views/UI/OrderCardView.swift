//
//  OrderCardView.swift
//  Fixe
//
//  Created by MRN7BAN on 26/10/25.
//

import SwiftUI

struct OrderCardView: View {
    
    var order: ServiceOrder
    
    var body: some View {
        HStack(alignment: .center){
            Spacer()
            Image(.washingMachine)
                .resizable()
                .scaledToFit()
                .frame(width: 35)
                .padding(.vertical,10)
                .padding(.horizontal,14)
                .background{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.accent.tertiary)
                }
                .padding()
            VStack(alignment: .leading){
                Text(order.eNumber)
                    .fontWeight(.bold)
                Text("Case ID: \(order.id.prefix(6))")              .font(.subheadline)
                    .foregroundStyle(.accent)
                Text("Request Cancellation | Status: \(order.status ?? "Unknown")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fontWeight(.light)
            }
            Spacer()
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    var stages: [ServiceStage] = [
        ServiceStage(date: "21/07/2023 09:40", title: "Case Registered", subtitle: "Issue - Beeping Sound", isCompleted: true),
        ServiceStage(date: "22/07/2023 10:40", title: "Allocated", subtitle: "Delhi NCR Branch", isCompleted: true),
        ServiceStage(date: "22/07/2023 01:40", title: "Engineer Assigned", subtitle: "Mohan Singh", isCompleted: true),
        ServiceStage(date: "22/07/2023 04:00", title: "OTP Received", subtitle: "3 4 3 2", isCompleted: true),
        ServiceStage(date: "23/07/2023 09:40", title: "Case Closed", subtitle: nil, isCompleted: true)
    ]
        var order: ServiceOrder = ServiceOrder(applianceType: "Washer", brand: "Bosch", eNumber: "SX658X03JE/01", problemDescription: "Sound while rotating", serviceType: "Genral", preferredDate: "23 Oct 2021", preferredTime: "2:33 PM", customerName: "Aravind", customerPhone: "7904175498", customerAddress: "H4 GCT OLD Staff Quartes, Madurai", status: "Pending", urgency: "High", stages: stages)
    
    OrderCardView(order: order)
}
