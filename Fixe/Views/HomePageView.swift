//
//  HomePageView.swift
//  Fixe
//
//  Created by MRN7BAN on 20/09/25.
//

import SwiftUI
import WebKit

struct HomePageView: View {
    
    @StateObject var viewModel = HomePageViewModel()
    @State var showDetailServiceview = false
    
    // Time-based greeting
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good morning!"
        case 12..<17:
            return "Good afternoon!"
        default:
            return "Good evening!"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                    // MARK: - Gradient Header
                    ZStack(alignment: .topTrailing) {
                        // Background gradient
                        LinearGradient(
                            colors: [
                                Color(red: 0.05, green: 0.15, blue: 0.45),
                                Color.hcBlue,
                                Color.hcBlueLight.opacity(0.85)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        
                        // Decorative floating dots
                        GeometryReader { geo in
                            ForEach(0..<8, id: \.self) { i in
                                Circle()
                                    .fill(Color.white.opacity(Double.random(in: 0.08...0.25)))
                                    .frame(width: CGFloat.random(in: 4...10))
                                    .position(
                                        x: CGFloat.random(in: 20...geo.size.width - 20),
                                        y: CGFloat.random(in: 20...geo.size.height * 0.6)
                                    )
                            }
                        }
                        
                        // Header content
                        VStack(alignment: .leading, spacing: 6) {
                            Spacer()
                                .frame(height: 50)
                            
                            Text(greeting)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(.white)
                            
                            HStack(spacing: 0) {
                                Text("Use Fixe to the fullest: ")
                                    .foregroundStyle(.white.opacity(0.85))
                                Text("Sign in")
                                    .fontWeight(.bold)
                                    .underline()
                                    .foregroundStyle(.white)
                                Text(" now!")
                                    .foregroundStyle(.white.opacity(0.85))
                            }
                            .font(.subheadline)
                            
                            Spacer()
                                .frame(height: 30)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        
                        // Notification bell
                        Button(action: {}) {
                            Image(systemName: "bell.fill")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                        }
                        .padding(.top, 54)
                        .padding(.trailing, 20)
                    }
                    .frame(height: 200)
                    .clipShape(
                        RoundedCorner(radius: 28, corners: [.bottomLeft, .bottomRight])
                    )
                    
                    // MARK: - Easy Access Section
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("Easy Access")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.hcTextPrimary)
                            
                            Spacer()
                            
                            Image(systemName: "plus.circle")
                                .font(.title3)
                                .foregroundStyle(Color.hcBlue)
                        }
                        .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 24) {
                                NavigationLink(destination: ServiceRequestView()) {
                                    HomeTile(icon: "wrench.and.screwdriver.fill", title: "Service")
                                }
                                
                                NavigationLink(destination: ServiceHistoryView()) {
                                    HomeTile(icon: "clock.arrow.circlepath", title: "History")
                                }
                                
                                NavigationLink(destination: MyProductsView()) {
                                    HomeTile(icon: "washer.fill", title: "Products")
                                }
                                
                                NavigationLink(destination: OffersView()) {
                                    HomeTile(icon: "tag.fill", title: "Offers")
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 4)
                        }
                    }
                    .padding(.top, 24)
                    
                    // MARK: - Recommended / Get Inspired
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Recommended")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.hcTextPrimary)
                        
                        Text("Get inspired")
                            .font(.headline)
                            .foregroundStyle(Color.hcTextSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 8)
            }
                
                // MARK: - WebView Inspiration (fills remaining space)
                WebView(url: URL(string: "https://www.home-connect.com/global/inspiration")!)
//                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
            
            // MARK: - Sticky Footer
            if viewModel.activeOrder != nil {
                OrderCardView(order: viewModel.activeOrder!)
                    .onTapGesture {
                        showDetailServiceview.toggle()
                    }
            }
        }
        .onAppear {
            Task {
                viewModel.fetchServiceOrder()
            }
        }
        .sheet(isPresented: $showDetailServiceview) {
            if let order = viewModel.activeOrder {
                DetailServiceView(order: order)
            }
        }
        .background(Color.hcBackground)
        .ignoresSafeArea(edges: .top)
    }
}


#Preview {
    NavigationStack {
        HomePageView()
    }
}
