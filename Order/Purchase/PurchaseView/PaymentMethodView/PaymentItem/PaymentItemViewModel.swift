//
//  PaymentItemViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 13.12.2024.
//

import Foundation

class PaymentItemViewModel: ObservableObject {
    private let toggleHandler: () -> Void
    
    @Published var viewState: Order.PaymentMethod
    
    init(viewState: Order.PaymentMethod,
         toggleHandler: @escaping () -> Void) {
        self.viewState = viewState
        self.toggleHandler = toggleHandler
    }
    
    func toggleChecked() {
        toggleHandler()
    }
}

