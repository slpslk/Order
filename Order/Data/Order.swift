//
//  Order.swift
//  Order
//
//  Created by Sofya Avtsinova on 19.10.2024.
//

import Foundation

struct Order {
    struct Promocode: Identifiable {
        let id: String = UUID().uuidString
        let title: String
        let percent: Int
        let endDate: Date?
        let info: String?
        var isActive: Bool 
    }

    struct Product: Identifiable {
        let id: String = UUID().uuidString
        let imagePath: String
        let title: String
        let count: Int
        let size: Double?
        let price: Double
        let discount: Int?
    }

    struct PaymentMethod: Identifiable {
        let id: String = UUID().uuidString
        let imagePath: String
        let title: String
        let discount: Int?
        let subtitle: String
        var isActive: Bool
    }

    var promocodes: [Promocode]
    var availableForActive: [Promocode]?
    var paymentMethods: [PaymentMethod]
    let products: [Product]
//    var paymentDiscount: Int
//    let baseDiscount: Int
    
    init(promocodes: [Promocode],
         availableForActive: [Promocode]? = nil,
         paymentMethods: [PaymentMethod],
         products: [Product]) throws {
        
        guard products.count != 0 else{
            throw OrderError.zeroProducts
        }
        
        try products.forEach {
            if $0.price <= 0 {
                throw OrderError.zeroProductPrice
            }
        }
        
        try promocodes.forEach{
            if $0.percent <= 0 || $0.percent > 100 {
                throw OrderError.dataError
            }
        }

        if promocodes.filter({$0.isActive}).count > 2 {
            throw OrderError.moreThanTwoPromocodes
        }
        
        self.promocodes = promocodes
        self.availableForActive = availableForActive
        self.paymentMethods = paymentMethods
        self.products = products
    }
}
