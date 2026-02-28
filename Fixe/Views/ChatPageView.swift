//
//  ChatPageView.swift
//  Fixe
//
//  Created by MRN7BAN on 20/09/25.
//

import SwiftUI

struct ChatPageView: View {
    @StateObject var viewModel = ChatPageViewModel()
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 4) {
                Text("Fixe Support")
                    .font(.headline)
                    .foregroundColor(Color.hcTextPrimary)
                
                if viewModel.isOrderComplete {
                    Text("✓ Order Complete")
                        .font(.caption)
                        .foregroundColor(.green)
                } else {
                    Text("Online")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .shadow(color: .black.opacity(0.05), radius: 3, y: 1)
            
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                        
                        // Loading indicator
                        if viewModel.isLoading {
                            HStack {
                                TypingIndicator()
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _ in
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input area
            VStack(spacing: 0) {
                Divider()
                
                HStack(spacing: 12) {
                    TextField("Type your message...", text: $viewModel.inputText)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding(12)
                        .background(Color.hcBackground)
                        .cornerRadius(20)
                        .focused($isInputFocused)
                        .onSubmit {
                            if !viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                viewModel.sendMessage()
                            }
                        }
                        .disabled(viewModel.isLoading || viewModel.isOrderComplete)
                    
                    Button(action: {
                        viewModel.sendMessage()
                        isInputFocused = true
                    }) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading || viewModel.isOrderComplete ? Color.gray.opacity(0.4) : Color.hcBlue)
                            )
                    }
                    .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading || viewModel.isOrderComplete)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .background(Color.white)
            
            // Reset button if order is complete
            if viewModel.isOrderComplete {
                Button(action: {
                    viewModel.resetConversation()
                }) {
                    Text("Start New Service Request")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.hcBlue, Color.hcBlueLight],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .cornerRadius(12)
                        )
                }
                .padding()
            }
        }
        .background(Color.hcBackground)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Message Bubble Component
struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isUser {
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.text)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(
                            LinearGradient(
                                colors: [Color.hcBlue, Color.hcBlueLight],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16, corners: [.topLeft, .topRight, .bottomLeft])
                    
                    Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: 250, alignment: .trailing)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.text)
                        .font(.body)
                        .foregroundColor(Color.hcTextPrimary)
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(16, corners: [.topLeft, .topRight, .bottomRight])
                        .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
                    
                    Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: 250, alignment: .leading)
                Spacer()
            }
        }
    }
}

// Typing Indicator Component
struct TypingIndicator: View {
    @State private var numberOfDots = 0
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.hcBlue)
                    .frame(width: 8, height: 8)
                    .opacity(numberOfDots > index ? 1 : 0.3)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.6).repeatForever()) {
                numberOfDots = 3
            }
        }
    }
}

// Extension for custom corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    NavigationView {
        ChatPageView()
    }
}
