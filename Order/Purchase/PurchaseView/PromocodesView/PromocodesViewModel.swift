//
//  PromocodesViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 14.12.2024.
//

import Foundation

class PromocodesViewModel: ObservableObject {
    @Published var promocodesInfo: [Order.Promocode]
    private var togglePromocode: (String) -> Void
    
    init(promocodesInfo: [Order.Promocode], togglePromocode: @escaping (String) -> Void) {
        self.promocodesInfo = promocodesInfo
        self.togglePromocode = togglePromocode
    }
      
    func toggleSelection(id: String) {
        togglePromocode(id)
    }
}
