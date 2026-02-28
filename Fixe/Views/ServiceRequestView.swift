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
    
    private let serviceTypes = ["Repair", "General Checkup"]
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - Service Type
                    SectionCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionLabel(text: "Service Type")
                            
                            HStack(spacing: 12) {
                                ForEach(serviceTypes, id: \.self) { type in
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            viewModel.order.serviceType = type
                                        }
                                    } label: {
                                        Text(type)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(
                                                viewModel.order.serviceType == type
                                                    ? AnyShapeStyle(LinearGradient(colors: [Color.hcBlue, Color.hcBlueLight], startPoint: .leading, endPoint: .trailing))
                                                    : AnyShapeStyle(Color.hcBackground)
                                            )
                                            .foregroundStyle(viewModel.order.serviceType == type ? .white : Color.hcTextPrimary)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                            }
                        }
                    }
                    
                    // MARK: - Appliance Info
                    SectionCard {
                        VStack(alignment: .leading, spacing: 14) {
                            SectionLabel(text: "Appliance Info")
                            
                            FormPickerRow(label: "Brand", selection: $viewModel.order.brand, options: Constants.ServiceDataProvider.brands)
                            
                            Divider()
                            
                            FormPickerRow(label: "Appliance", selection: $viewModel.order.applianceType, options: Constants.ServiceDataProvider.applianceTypes)
                            
                            Divider()
                            
                            FormTextField(label: "ENumber", text: $viewModel.order.eNumber)
                        }
                    }
                    
                    // MARK: - Problem Description (only for Repair)
                    if viewModel.order.serviceType == "Repair" {
                        SectionCard {
                            VStack(alignment: .leading, spacing: 12) {
                                SectionLabel(text: "Problem Description")
                                
                                TextField("Describe the issue...", text: $viewModel.order.problemDescription, axis: .vertical)
                                    .font(.body)
                                    .lineLimit(3...6)
                                    .padding(12)
                                    .background(Color.hcBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    // MARK: - Customer Info
                    SectionCard {
                        VStack(alignment: .leading, spacing: 14) {
                            SectionLabel(text: "Customer Info")
                            
                            FormTextField(label: "Name", text: $viewModel.order.customerName)
                            Divider()
                            FormTextField(label: "Phone", text: $viewModel.order.customerPhone, keyboard: .phonePad)
                            Divider()
                            FormTextField(label: "Address", text: $viewModel.order.customerAddress)
                        }
                    }
                    
                    // MARK: - Select Slot
                    SectionCard {
                        VStack(alignment: .leading, spacing: 16) {
                            SectionLabel(text: "Select Slot")
                            
                            // Day selector
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(viewModel.availableDays, id: \.self) { day in
                                        DayPill(date: day, isSelected: Calendar.current.isDate(day, inSameDayAs: viewModel.selectedDay))
                                            .onTapGesture {
                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                    viewModel.selectedDay = day
                                                    viewModel.selectedSlot = nil
                                                }
                                            }
                                    }
                                }
                            }
                            
                            // Time slots grid
                            let slots = viewModel.availableSlots(for: viewModel.selectedDay)
                            
                            if slots.isEmpty {
                                HStack {
                                    Image(systemName: "clock.badge.xmark")
                                        .foregroundStyle(Color.hcTextSecondary)
                                    Text("No slots available for this day")
                                        .font(.subheadline)
                                        .foregroundStyle(Color.hcTextSecondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                            } else {
                                LazyVGrid(columns: [
                                    GridItem(.flexible(), spacing: 10),
                                    GridItem(.flexible(), spacing: 10)
                                ], spacing: 10) {
                                    ForEach(slots) { slot in
                                        SlotButton(
                                            slot: slot,
                                            isSelected: viewModel.selectedSlot?.id == slot.id
                                        ) {
                                            withAnimation(.easeInOut(duration: 0.15)) {
                                                viewModel.selectedSlot = slot
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 16)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
            
            // MARK: - Submit Button
            Button {
                if viewModel.isFormValid() {
                    viewModel.initializeServiceStages()
                    Task {
                        let result = await viewModel.saveToHistory()
                        if result {
                            showSuccess = true
                            validationMessage = "Service order successfully created"
                            showValidationAlert = true
                        } else {
                            showSuccess = false
                            validationMessage = "Service order not created, try again later."
                            showValidationAlert = true
                        }
                    }
                } else {
                    showSuccess = false
                    validationMessage = "Please fill all required fields and select a time slot."
                    showValidationAlert = true
                }
            } label: {
                Text("Submit Order")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color.hcBlue, Color.hcBlueLight],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: Color.hcBlue.opacity(0.3), radius: 8, y: 4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .alert(showSuccess ? "Order Created" : "Warning", isPresented: $showValidationAlert) {
                Button("OK", role: .cancel) {
                    if showSuccess {
                        dismiss()
                    }
                }
            } message: {
                Text(validationMessage)
            }
        }
        .background(Color.hcBackground)
        .navigationTitle("Service Request")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

// MARK: - Section Card Container
struct SectionCard<Content: View>: View {
    @ViewBuilder let content: Content
    
    var body: some View {
        content
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: Color.black.opacity(0.04), radius: 6, y: 2)
    }
}

// MARK: - Section Label
struct SectionLabel: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundStyle(Color.hcTextPrimary)
    }
}

// MARK: - Form Picker Row
struct FormPickerRow: View {
    let label: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(Color.hcTextSecondary)
            Spacer()
            Picker("", selection: $selection) {
                Text("Select").tag("")
                ForEach(options, id: \.self) { Text($0).tag($0) }
            }
            .pickerStyle(.menu)
            .tint(Color.hcBlue)
        }
    }
}

// MARK: - Form Text Field
struct FormTextField: View {
    let label: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(Color.hcTextSecondary)
                .frame(width: 70, alignment: .leading)
            TextField(label, text: $text)
                .font(.body)
                .keyboardType(keyboard)
        }
    }
}

// MARK: - Day Pill
struct DayPill: View {
    let date: Date
    let isSelected: Bool
    
    private var dayName: String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            return "Today"
        }
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(dayName)
                .font(.caption2)
                .fontWeight(.medium)
            Text(dayNumber)
                .font(.title3)
                .fontWeight(.bold)
        }
        .frame(width: 52, height: 60)
        .background(
            isSelected
                ? AnyShapeStyle(LinearGradient(colors: [Color.hcBlue, Color.hcBlueLight], startPoint: .top, endPoint: .bottom))
                : AnyShapeStyle(Color.hcBackground)
        )
        .foregroundStyle(isSelected ? .white : Color.hcTextPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Slot Button
struct SlotButton: View {
    let slot: TimeSlot
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "clock")
                    .font(.caption)
                Text(slot.label)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                isSelected
                    ? AnyShapeStyle(Color.hcBlue.opacity(0.12))
                    : AnyShapeStyle(Color.hcBackground)
            )
            .foregroundStyle(isSelected ? Color.hcBlue : Color.hcTextPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(isSelected ? Color.hcBlue : Color.clear, lineWidth: 1.5)
            )
        }
    }
}

#Preview {
    NavigationStack {
        ServiceRequestView()
    }
}
