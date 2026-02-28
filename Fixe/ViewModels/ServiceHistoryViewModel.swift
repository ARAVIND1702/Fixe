//
//  ServiceHistoryViewModel.swift
//  Fixe
//
//  Created by MRN7BAN on 16/10/25.
//

import Foundation

class ServiceHistoryViewModel: ObservableObject {
    
    @Published var orders: [ServiceOrder] = []
    private let firebaseService = FirebaseService()
    
    func fetchServiceOrder(){
        let userId = SessionManager.shared.userId
        firebaseService.fetchOrdersForUser(userId: userId) { [weak self] fetchedOrders in
            DispatchQueue.main.async {
                self?.orders = fetchedOrders
            }
        }
    }
    
    
}
