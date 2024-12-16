//
//  OrderService.swift
//  Order
//
//  Created by Sofya Avtsinova on 14.12.2024.
//

import Foundation
import Combine

struct Summary {
    var productsCount: Int
    var productsPrice: Double
    var promocodeAmount: Double
    var baseDiscountAmount: Double
    var paymentDiscountAmount: Double
    var totalPrice: Double
}

enum PromocodeAction {
    case reload(Order.Promocode)
    case addNew(Order.Promocode)
    case error(OrderError)
}

enum PaymentMethodAction {
    case reload(Order.PaymentMethod)
    case error(OrderError)
}

protocol OrderServicing: PromocodeObserving,  PaymentMethodObserving, SummaryObserving {
    var initialState: OrderState { get }
    func setPromocodeActivity(for id: String)
    func togglePaymentMethod(for id: String)
    func findPromocodeByTitle(title: String) -> String?
    func addNewPromocode(id newPromocodeID: String)
}

protocol PromocodeObserving {
    var promocodePublisher: AnyPublisher<PromocodeAction, Never> { get }
}

protocol PaymentMethodObserving {
    var paymentMethodPublisher: AnyPublisher<PaymentMethodAction, Never> { get }
}

protocol SummaryObserving {
    var summaryPublisher: AnyPublisher<Summary, Never> { get }
}

final class OrderService {
    private var order: Order
    private let promocodeSubject = PassthroughSubject<PromocodeAction, Never>()
    private let summarySubject = PassthroughSubject<Summary, Never>()
    private let paymentMethodSubject = PassthroughSubject<PaymentMethodAction, Never>()
    
    init(order: Order) throws {
        self.order = order
        
        do {
            try checkData()
        } catch let error {
            throw error
        }
    }
}

extension OrderService: OrderServicing {
    var promocodePublisher: AnyPublisher<PromocodeAction, Never> {
        promocodeSubject.eraseToAnyPublisher()
    }
    
    var paymentMethodPublisher: AnyPublisher<PaymentMethodAction, Never> {
        paymentMethodSubject.eraseToAnyPublisher()
    }
    
    var summaryPublisher: AnyPublisher<Summary, Never> {
        summarySubject.eraseToAnyPublisher()
    }
    
    var initialState: OrderState {
        OrderState(order: order, summary: .init(productsCount: productsCount,
                                                productsPrice: productsPrice,
                                                promocodeAmount: promocodeAmount,
                                                baseDiscountAmount: baseDiscountAmount,
                                                paymentDiscountAmount: paymentDiscountAmount,
                                                totalPrice: totalPrice))
    }

    func setPromocodeActivity(for id: String) {
        if let promoIndex = order.promocodes.firstIndex(where: { $0.id == id }) {
            order.promocodes[promoIndex].isActive.toggle()
            if activePromocodesCount > 2 {
                order.promocodes[promoIndex].isActive.toggle()
                promocodeSubject.send(.error(OrderError.moreThanTwoPromocodes))
            }
            if totalPrice <= 0 {
                order.promocodes[promoIndex].isActive.toggle()
                
                promocodeSubject.send(.error(OrderError.tooBigDiscount))
            }
            promocodeSubject.send(.reload(order.promocodes[promoIndex]))
        }
        
        if let availablePromoIndex = order.availableForActive?.firstIndex(where: { $0.id == id}) {
            order.availableForActive?[availablePromoIndex].isActive.toggle()
            if activePromocodesCount > 2 {
                order.availableForActive?[availablePromoIndex].isActive.toggle()
                promocodeSubject.send(.error(OrderError.moreThanTwoPromocodes))
            }
            if totalPrice <= 0 {
                order.availableForActive?[availablePromoIndex].isActive.toggle()
                promocodeSubject.send(.error(OrderError.tooBigDiscount))
            }
            if let currentPromocode = order.availableForActive?[availablePromoIndex] {
                promocodeSubject.send(.reload(currentPromocode))
            }
        }
        summarySubject.send(.init(productsCount: productsCount,
                                  productsPrice: productsPrice,
                                  promocodeAmount: promocodeAmount,
                                  baseDiscountAmount: baseDiscountAmount,
                                  paymentDiscountAmount: paymentDiscountAmount,
                                  totalPrice: totalPrice))
    }
    
    func togglePaymentMethod(for id: String) {
        if let paymentIndex = order.paymentMethods.firstIndex(where: { $0.id == id }) {
            order.paymentMethods[paymentIndex].isActive.toggle()
            
            if totalPrice <= 0 {
                order.paymentMethods[paymentIndex].isActive.toggle()
                paymentMethodSubject.send(.error(OrderError.tooBigDiscount))
            }
            paymentMethodSubject.send(.reload(order.paymentMethods[paymentIndex]))
        }
        summarySubject.send(.init(productsCount: productsCount,
                                  productsPrice: productsPrice,
                                  promocodeAmount: promocodeAmount,
                                  baseDiscountAmount: baseDiscountAmount,
                                  paymentDiscountAmount: paymentDiscountAmount,
                                  totalPrice: totalPrice))
    }
    
    func findPromocodeByTitle(title: String) -> String? {
        if let avaliablePromocode = order.availableForActive?.first(where: {
            title == $0.title
        }){
            return avaliablePromocode.id
        } else {
            return nil
        }
    }
    
    func addNewPromocode(id newPromocodeID: String)  {
        if let newPromocodeIndex = order.availableForActive?.firstIndex(where: {$0.id == newPromocodeID}) {
            if activePromocodesCount == 2 {
                if let lastActivePromoIndex = order.promocodes.lastIndex(where: {$0.isActive}) {
                    order.promocodes[lastActivePromoIndex].isActive.toggle()
                    order.availableForActive?[newPromocodeIndex].isActive = true
                    if totalPrice <= 0 {
                        order.availableForActive?[newPromocodeIndex].isActive = false
                        order.promocodes[lastActivePromoIndex].isActive.toggle()
                        promocodeSubject.send(.error(OrderError.tooBigDiscount))
                    }
                    let lastActivePromo = order.promocodes[lastActivePromoIndex]
                    promocodeSubject.send(.reload(lastActivePromo))
                }
            } else {
                order.availableForActive?[newPromocodeIndex].isActive = true
                if totalPrice <= 0 {
                    order.availableForActive?[newPromocodeIndex].isActive = false
                    promocodeSubject.send(.error(OrderError.tooBigDiscount))
                }
            }
            if let newPromocode = order.availableForActive?[newPromocodeIndex] {
                promocodeSubject.send(.addNew(newPromocode))
            }
        }
    }
}


private extension OrderService {
    var productsPrice: Double {
        order.products.reduce(0, {$0 + $1.price})
    }
    
    var productsCount: Int {
        order.products.count
    }
    
    var promocodeAmount: Double {
        productsPrice * Double(promocodePercent)/100
    }
    
    var baseDiscountAmount: Double {
        productsPrice * Double(baseDiscount)/100
    }
    
    var paymentDiscountAmount: Double {
        productsPrice * Double(paymentDiscount)/100
    }
    
    var totalPrice: Double {
        productsPrice - promocodeAmount - baseDiscountAmount - paymentDiscountAmount
    }
    
    var promocodePercent: Int {
        let basePromocodes = order.promocodes.reduce(0) { sum, promocode in
            promocode.isActive ? sum + promocode.percent : sum
        }
        let avaliablePromocodes = order.availableForActive?.reduce(0) { sum, promocode in
            promocode.isActive ? sum + promocode.percent : sum
        }
        
        return basePromocodes + (avaliablePromocodes ?? 0)
    }
    
    var activePromocodesCount: Int {
        let baseCount = order.promocodes.filter({$0.isActive}).count
        let avaliableCount = order.availableForActive?.filter({$0.isActive}).count
        
        return baseCount + (avaliableCount ?? 0)
    }
    
    var baseDiscount: Int {
        order.products.reduce(0, {$1.discount ?? 0})
    }
    
    var paymentDiscount: Int {
        order.paymentMethods.first(where: {$0.isActive})?.discount ?? 0
    }
    
    func checkData() throws {
        if totalPrice <= 0 {
            throw OrderError.tooBigDiscount
        }
    }
}
