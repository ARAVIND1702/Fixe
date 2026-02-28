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
        HStack(alignment: .center, spacing: 14) {
            Image(.washingMachine)
                .resizable()
                .scaledToFit()
                .frame(width: 35)
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.hcBlue.opacity(0.1))
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(order.eNumber)
                    .font(.headline)
                    .foregroundStyle(Color.hcTextPrimary)
                Text("Case ID: \(order.id.prefix(6))")
                    .font(.subheadline)
                    .foregroundStyle(Color.hcBlue)
                Text("Status: \(order.status ?? "Unknown")")
                    .font(.caption)
                    .foregroundStyle(Color.hcTextSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(Color.hcTextSecondary)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 6, y: 2)
        )
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

#Preview {
    var order: ServiceOrder = ServiceOrder(applianceType: "Washer", brand: "Bosch", eNumber: "SX658X03JE/01", problemDescription: "Sound while rotating", serviceType: "Genral", preferredDate: "23 Oct 2021", preferredTime: "2:33 PM", customerName: "Aravind", customerPhone: "7904175498", customerAddress: "H4 GCT OLD Staff Quartes, Madurai", status: "Pending", urgency: "High")
    
    OrderCardView(order: order)
}
