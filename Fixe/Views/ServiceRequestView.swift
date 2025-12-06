//
//  ServiceRequestView.swift
//  Fixe
//
//  Created by MRN7BAN on 12/10/25.
//

import SwiftUI

struct ServiceRequestView: View {
    
    @StateObject private var viewModel = ServiceRequestViewModel()
    @State private var showSuccess = false
    @State private var showValidationAlert = false
    @State private var validationMessage = ""
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        let now = Date()
        let sevenDaysFromNow = Calendar.current.date(byAdding: .day, value: 7, to: now)!
        let dateRange: ClosedRange<Date> = now...sevenDaysFromNow
        VStack(spacing: 0) {
            Form {
                Section(header: Text("Appliance Info")) {
                    Picker("Brand:", selection: $viewModel.order.brand) {
                        ForEach(Constants.ServiceDataProvider.brands, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.menu)
                    
                    Picker("Appliance Type:", selection: $viewModel.order.applianceType) {
                        ForEach(Constants.ServiceDataProvider.applianceTypes, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.menu)
                    
                    TextField("ENumber", text: $viewModel.order.eNumber)
                        .textInputAutocapitalization(.characters)
                    
                }
                
                Section(header: Text("Service Details")) {
                    Picker("Service Type:", selection: $viewModel.order.serviceType) {
                        ForEach(Constants.ServiceDataProvider.serviceTypes, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.menu)
                    TextField("Describe Problem", text: $viewModel.order.problemDescription, axis: .vertical)
                }
                
                Section(header: Text("Customer Info")) {
                    TextField("Name", text: $viewModel.order.customerName)
                    TextField("Phone", text: $viewModel.order.customerPhone)
                        .keyboardType(.phonePad)
                    TextField("Address", text: $viewModel.order.customerAddress)
                }
                
                Section(header: Text("Preferred Schedule")) {
                    DatePicker(
                        "Select Date:",
                        selection: $viewModel.selectedDate, in: dateRange,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    Picker("Urgency: ", selection: $viewModel.order.urgency) {
                        ForEach(Constants.ServiceDataProvider.urgencyLevels, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.menu)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Service Request")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            
            Button {
                if viewModel.isFormValid() {
                    viewModel.initializeServiceStages()
                    Task{
                        let result = await viewModel.saveToHistory()  // Save locally
                        if result == true {
                            showSuccess = true
                            validationMessage = "Service order sucessfully created"
                            showValidationAlert = true
                            
                        } else {
                            showSuccess = false
                            validationMessage = "Service order not created try again later."
                            showValidationAlert = true
                        }
                    }
                } else {
                    showSuccess = false
                    validationMessage = "Please fill all required fields before submitting."
                    showValidationAlert = true
                }
            } label: {
                Text("Submit Order")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical,18)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(18)
            }
            .alert(showSuccess ? "Order Created":"Warning", isPresented: $showValidationAlert) {
                Button("OK", role: .cancel) {
                    if showSuccess{
                        dismiss()
                    }
                }
            } message: {
                Text(validationMessage)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        
    }
}



#Preview {
    ServiceRequestView()
}
