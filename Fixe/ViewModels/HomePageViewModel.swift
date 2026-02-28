//
//  HomePageViewModel.swift
//  Fixe
//
//  Created by MRN7BAN on 26/10/25.
//

import Foundation

class HomePageViewModel: ObservableObject {
    @Published var orders: [ServiceOrder] = []
    @Published var activeOrder: ServiceOrder?
    private let firebaseService = FirebaseService()

    func fetchServiceOrder() {
        let userId = SessionManager.shared.userId
        firebaseService.fetchOrdersForUser(userId: userId) { [weak self] fetchedOrders in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.orders = fetchedOrders

                // Now that orders are assigned, compute activeOrder
                self.configureActiveOrder(from: fetchedOrders)
            }
        }
    }

    private func configureActiveOrder(from orders: [ServiceOrder]) {
        // Prefer exact "Pending" (case-insensitive). You can change priority logic here.
        if let pending = orders.first(where: { ($0.status ?? "").lowercased() == "pending" }) {
            self.activeOrder = pending
        } else {
            // If no pending, optionally pick in-progress or nil
            self.activeOrder = orders.first
        }
    }
}
