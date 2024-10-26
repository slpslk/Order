//
//  Order.swift
//  Order
//
//  Created by Sofya Avtsinova on 19.10.2024.
//

import Foundation

struct Order {
    struct Promocode {
        let id: String = UUID().uuidString
        let title: String
        let percent: Int
        let endDate: Date?
        let info: String?
        var active: Bool 
    }

    struct Product {
        let price: Double
        let title: String
    }

    var screenTitle: String
    var promocodes: [Promocode]
    var availableForActive: [Promocode]?
    let products: [Product]
    let paymentDiscount: Double?
    let baseDiscount: Double?
}
