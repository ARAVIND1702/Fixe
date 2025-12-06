//
//  DetailServiceView.swift
//  Fixe
//
//  Created by MRN7BAN on 19/10/25.
//

import SwiftUI

struct DetailServiceView: View {
    
    @Environment(\.dismiss) var dismiss   // 👈 For closin
    @StateObject var viewModel = DetailServiceViewModel()
    var order: ServiceOrder
    

    
    var body: some View {
        
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    dismiss()   // Close the sheet
                }) {
                    Image(systemName: "xmark")
                        .font(.headline)
                }
            }.padding()
            
            // MARK: - Sticky Footer
            HStack(alignment: .center){
                Spacer()
                Image(.washingMachine)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45)
                    .padding(.vertical,12)
                    .padding(.horizontal,16)
                    .background{
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.accent.tertiary)
                    }
                    .padding()
                
                VStack(alignment: .leading){
                    
                    Text(order.eNumber)
                        .fontWeight(.bold)
                    
                    Text("Case ID: 745820")
                        .font(.footnote)
                        .foregroundStyle(.accent)
                    
                    Text("Problem Description:")
                        .font(.caption)
                        .foregroundColor(.appSecondary)
                    
                    Text("\(order.problemDescription)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Address:")
                        .font(.caption)
                        .foregroundColor(.appSecondary)
                    
                    Text("\(order.customerAddress)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("Date & Time:")
                        .font(.caption)
                        .foregroundColor(.appSecondary)
                    
                    Text("\(order.preferredDate) | \(order.preferredTime)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Spacer()
                Spacer()
            }
            
            Divider()
                .padding()
            
            // MARK: - Time Line
            ScrollView(){
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
            Button{
                
            }label: {
                Text("Cancel Order")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical,18)
                    .background(Color.secondaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(18)
            }            
        }
        .padding()
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
        
        
    DetailServiceView(order: order)
}
