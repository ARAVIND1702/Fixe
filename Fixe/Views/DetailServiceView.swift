//
//  DetailServiceView.swift
//  Fixe
//
//  Created by MRN7BAN on 19/10/25.
//

import SwiftUI

struct DetailServiceView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = DetailServiceViewModel()
    var order: ServiceOrder
    
    var body: some View {
        
        VStack(spacing: 0) {
            // MARK: - Header
            HStack {
                Text("Service Detail")
                    .font(.headline)
                    .foregroundStyle(Color.hcTextPrimary)
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(Color.hcTextSecondary)
                }
            }
            .padding()
            
            // MARK: - Order Info Card
            HStack(alignment: .center) {
                Image(.washingMachine)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.hcBlue.opacity(0.1))
                    }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.eNumber)
                        .font(.headline)
                        .foregroundStyle(Color.hcTextPrimary)
                    
                    Text("Case ID: 745820")
                        .font(.footnote)
                        .foregroundStyle(Color.hcBlue)
                    
                    Text("Problem:")
                        .font(.caption)
                        .foregroundColor(Color.hcTextSecondary)
                    
                    Text("\(order.problemDescription)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Address:")
                        .font(.caption)
                        .foregroundColor(Color.hcTextSecondary)
                    
                    Text("\(order.customerAddress)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Date & Time:")
                        .font(.caption)
                        .foregroundColor(Color.hcTextSecondary)
                    
                    Text("\(order.preferredDate) | \(order.preferredTime)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 6, y: 2)
            )
            .padding(.horizontal)
            
            Divider()
                .padding()
            
            // MARK: - Time Line
            ScrollView() {
                VStack(alignment: .leading) {
                    ForEach(order.stages.indices, id: \.self) { index in
                        TimelineRow(
                            stage: order.stages[index],
                            isLast: index == order.stages.count - 1
                        )
                    }
                }
                .padding()
            }
            
            // MARK: - Cancel
            Button {
                
            } label: {
                Text("Cancel Order")
                    .font(.headline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.red.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            .padding()
        }
        .background(Color.hcBackground)
    }
}

#Preview {
    var order: ServiceOrder = ServiceOrder(applianceType: "Washer", brand: "Bosch", eNumber: "SX658X03JE/01", problemDescription: "Sound while rotating", serviceType: "Genral", preferredDate: "23 Oct 2021", preferredTime: "2:33 PM", customerName: "Aravind", customerPhone: "7904175498", customerAddress: "H4 GCT OLD Staff Quartes, Madurai", status: "Pending", urgency: "High", stages: [
        ServiceStage(date: "21/07/2023 09:40", title: "Case Registered", subtitle: "Issue - Beeping Sound", isCompleted: true),
        ServiceStage(date: "22/07/2023 10:40", title: "Allocated", subtitle: "Delhi NCR Branch", isCompleted: true),
        ServiceStage(date: "22/07/2023 01:40", title: "Engineer Assigned", subtitle: "Mohan Singh", isCompleted: true),
        ServiceStage(date: "22/07/2023 04:00", title: "OTP Received", subtitle: "3 4 3 2", isCompleted: true),
        ServiceStage(date: "23/07/2023 09:40", title: "Case Closed", subtitle: nil, isCompleted: true)
    ])
    
    DetailServiceView(order: order)
}
