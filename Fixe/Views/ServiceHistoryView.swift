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
    @State private var selectedOrder: ServiceOrder? = nil

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.hcBlue))
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
                    VStack(spacing: 12) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 48))
                            .foregroundStyle(Color.hcTextSecondary)
                        Text("No service history available.")
                            .foregroundColor(Color.hcTextSecondary)
                    }
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
                                        .foregroundStyle(Color.hcTextPrimary)
                                    
                                    Spacer()
                                    
                                    Text(order.status ?? "Pending")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(order.status == "Closed" ? Color.green.opacity(0.15) : Color.hcBlue.opacity(0.12))
                                        .foregroundStyle(order.status == "Closed" ? Color.green : Color.hcBlue)
                                        .cornerRadius(6)
                                }
                                
                                Text("Problem: \(order.problemDescription)")
                                    .font(.subheadline)
                                    .foregroundColor(Color.hcTextSecondary)
                                
                                Text("Date: \(order.preferredDate) | Time: \(order.preferredTime)")
                                    .font(.caption)
                                    .foregroundColor(Color.hcTextSecondary)
                            }
                            .padding(.vertical, 6)
                        }
                        .buttonStyle(.plain)
                    }
                    .listStyle(.plain)
                }
            }
        }
        .sheet(item: $selectedOrder) { order in
            DetailServiceView(order: order)
        }
        .navigationTitle("Service History")
        .background(Color.hcBackground)
    }
}

#Preview {
    ServiceHistoryView()
}
