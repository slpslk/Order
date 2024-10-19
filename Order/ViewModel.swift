//
//  ViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 19.10.2024.
//

import Foundation
import UIKit

class ViewModel {
    weak var delegate: TableViewUpdateDelegate?
    
    lazy var products: [Order.Product] = [
        .init(price: 1200, title: "Товар 1"),
        .init(price: 5800, title: "Товар 2"),
        .init(price: 7500, title: "Товар 3"),
    ]
    
    lazy var promocodes: [Order.Promocode] = [
        .init(title: "HELLO",
              percent: 70,
              endDate: nil,
              info: "Промокод действует на первый заказ в приложении",
              active: false),
        .init(title: "NSK2024",
              percent: 20,
              endDate: Date(timeIntervalSince1970: 1732924800),
              info: "Промокод действует для заказов от 3000 ₽",
              active: true),
        .init(title: "New Year",
              percent: 15,
              endDate: Date(timeIntervalSince1970: 1735603200),
              info: nil,
              active: true),
     ]
    
    lazy var orderInfo = Order(screenTitle: "Промокоды",
                               promocodes: promocodes,
                               products: products,
                               paymentDiscount: 500,
                               baseDiscount: 500)
    
    
    lazy var cellViewModels: [TableCellViewModel] = [
        .init(type: .title(.init(title: "Промокоды",
                                 subtitle: "На один товар можно применить только один промокод"))),
        .init(type: .applyButton(.init(title: "Применить промокод",
                                       image: UIImage(named: "promoIcon")))),
    ]
    
    func madeData() throws {
        orderInfo.promocodes.forEach({
            cellViewModels.append(.init(type: .promocode(.init(id: $0.id,
                                                               title: $0.title,
                                                               percent: $0.percent,
                                                               endDate: $0.endDate,
                                                               info: $0.info,
                                                               isActive: $0.active,
                                                               toggle: { id in self.togglePromo( id: id)}
                                                              ))))
        })
        
        let productCountString = "Цена за \(productsCount) товара"
        
        cellViewModels.append(.init(type: .hideButton(.init())))
        
        cellViewModels.append(.init(type: .totalPrice(.init(allPriceTitle: productCountString,
                                                            allPrice: productsPrice,
                                                            discountAmount: orderInfo.baseDiscount,
                                                            promocodeAmount: promocodeAmount,
                                                            paymentAmount: orderInfo.paymentDiscount,
                                                            totalPrice: totalPrice))))
        
        cellViewModels.append(.init(type: .orderButton(.init())))
        
        try checkData()
    }
    
    func togglePromo(id: String) -> Bool {
        if let promoIndex = orderInfo.promocodes.firstIndex(where: { $0.id == id}) {
            orderInfo.promocodes[promoIndex].active.toggle()
            if totalPrice <= 0 {
                orderInfo.promocodes[promoIndex].active.toggle()
                delegate?.showAlert("Сумма текущей скидки не может быть больше суммы заказа")
                return false
            }
            
            updateTotalPriceCell()
        }
        return true
    }
}

private extension ViewModel {
    var promocodePercent: Int {
        orderInfo.promocodes.reduce(0) { sum, promocode in
            promocode.active ? sum + promocode.percent : sum
        }
    }
    
    var productsCount: Int {
        orderInfo.products.count
    }
    
    var productsPrice: Double {
        orderInfo.products.reduce(0,{$0 + $1.price})
    }
    
    var promocodeAmount: Double? {
        promocodePercent > 0 ? productsPrice * Double(promocodePercent)/100 : nil
    }
    
    var totalPrice: Double {
        productsPrice - (orderInfo.baseDiscount ?? 0) - (orderInfo.paymentDiscount ?? 0) - (promocodeAmount ?? 0)
    }
    
    func checkData() throws {
        guard productsCount != 0 else{
            throw OrderError.zeroProducts
        }
        
        try orderInfo.products.forEach {
            if $0.price <= 0 {
                throw OrderError.zeroProductPrice
            }
        }
        
        if totalPrice <= 0 {
            throw OrderError.tooBigDiscount
        }
    }
    
    func updateTotalPriceCell() {
            if let totalPriceIndex = cellViewModels.firstIndex(where: {
                if case .totalPrice = $0.type {
                    return true
                }
                return false
            }) {
                if case var .totalPrice(totalInfo) = cellViewModels[totalPriceIndex].type {
                    totalInfo.totalPrice = totalPrice
                    totalInfo.promocodeAmount = promocodeAmount
                    cellViewModels[totalPriceIndex].type = .totalPrice(totalInfo)

                    let indexPath = IndexPath(row: totalPriceIndex, section: 0)
                    delegate?.reloadRow(at: indexPath)
                }
            }
        }
    
}
