//
//  ServiceHistoryView.swift
//  Fixe
//
//  Created by MRN7BAN on 16/10/25.
//

import SwiftUI

struct ServiceHistoryView: View {
    
    @StateObject private var viewModel = ServiceHistoryViewModel()
    @State private var isLoading = true
    @State private var showDetailServiceView = false
    @State private var selectedOrder: ServiceOrder? = nil // 👈 to store tapped order

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                    .scaleEffect(2.0)
                    .onAppear {
                        Task {
                             viewModel.fetchServiceOrder()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                isLoading = false
                            }
                        }
                    }
            } else {
                if viewModel.orders.isEmpty {
                    Text("No service history available.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.orders) { order in
                        Button {
                            selectedOrder = order
                            showDetailServiceView = true
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(order.eNumber)
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    Text(order.status ?? "Pending")
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(order.status == "Closed" ? Color.green.opacity(0.2) : Color.accentColor.opacity(0.2))
                                        .cornerRadius(6)
                                }
                                
                                Text("Problem: \(order.problemDescription)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("Date: \(order.preferredDate) | Time: \(order.preferredTime)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 6)
                        }
                        .buttonStyle(.plain) // removes default blue tint
                    }
                    .listStyle(.plain)
                }
            }
        }
        // 👇 Present sheet only if selectedOrder is not nil
        .sheet(item: $selectedOrder) { order in
            DetailServiceView(order: order)
        }
        .navigationTitle("Service History")
    }
}

#Preview {
    ServiceHistoryView()
}

