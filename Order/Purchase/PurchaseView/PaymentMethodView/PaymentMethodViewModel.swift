//
//  PaymentMethodViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 13.12.2024.
//

import Foundation

class PaymentMethodViewModel: ObservableObject {
    @Published var paymentMethodsInfo: [Order.PaymentMethod]
    private let togglePaymentMethod: (String) -> Void
    
    init(paymentMethodsInfo: [Order.PaymentMethod], togglePaymentMethod: @escaping (String) -> Void) {
        self.paymentMethodsInfo = paymentMethodsInfo
        self.togglePaymentMethod = togglePaymentMethod
    }
    
    func toggleSelection(for item: Order.PaymentMethod) {
        togglePaymentMethod(item.id)
    }
}
