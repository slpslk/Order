//
//  PromocodeCardViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 15.12.2024.
//

import Foundation

class PromocodeCardViewModel: ObservableObject {
    @Published var promocodeModel: Order.Promocode
    private let toggleHandler: () -> Void
    
    init(promocodeModel: Order.Promocode, toggleHandler: @escaping () -> Void) {
        self.promocodeModel = promocodeModel
        self.toggleHandler = toggleHandler
    }
    
    func toggleChecked() {
        toggleHandler()
    }
}
