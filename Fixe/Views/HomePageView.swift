//
//  HomePageView.swift
//  Fixe
//
//  Created by MRN7BAN on 20/09/25.
//

import SwiftUI

struct HomePageView: View {
    
    @StateObject var viewModel = HomePageViewModel()
    
    @State var selectedTab = 0
    @State var showDetailServiceview = false
    
    private let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        VStack(spacing: 0){
            ScrollView { // Keeps everything top-aligned
                LazyVGrid(columns: columns, spacing: 15) {
                    
                    // MARK: - Request Service
                    NavigationLink(destination: ServiceRequestView()) {
                        HomeTile(icon: "wrench.and.screwdriver.fill", title: "Service")
                    }
                    
                    // MARK: - History
                    NavigationLink(destination: ServiceHistoryView()) {
                        HomeTile(icon: "clock.arrow.circlepath", title: "History")
                    }
                    
                    // MARK: - Products
                    NavigationLink(destination: MyProductsView()) {
                        HomeTile(icon: "washer.fill", title: "Products")
                    }
                    
                    // MARK: - Offers
                    NavigationLink(destination: MyProductsView()) {
                        HomeTile(icon: "tag", title: "Offers")
                    }
                }
                .padding()
                .navigationTitle("Home")
                
            }
            
            // MARK: - Sticky Footer
            if(viewModel.activeOrder != nil) {
                OrderCardView(order: viewModel.activeOrder!)
                    .onTapGesture {
                        showDetailServiceview.toggle()
                    }
                    .background(Color.white)
                    .border(.accent.tertiary, width: 0.7,)
            }
        }
        .onAppear{
            Task {
                viewModel.fetchServiceOrder()
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                //                    isLoading = false
                //                }
            }
        }
        .sheet(isPresented: $showDetailServiceview) {
            if let order = viewModel.activeOrder {
                DetailServiceView(order: order)
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}
#Preview {
    NavigationStack {
        HomePageView()
    }
    
}
