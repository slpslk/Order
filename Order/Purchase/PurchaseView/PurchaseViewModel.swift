//
//  PurchaseViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 12.12.2024.
//

import Foundation
import Combine

struct OrderState {
    var order: Order
    var summary: Summary
}

enum PurchaseViewError {
    case none
    case error(String)
}

class PurchaseViewModel: ObservableObject {
    var orderService: OrderService
    @Published var orderState: OrderState
    @Published var error: PurchaseViewError = .none
    
    private var promocodeSubscription: AnyCancellable?
    private var paymentMethodSubscription: AnyCancellable?
    private var summarySubscription: AnyCancellable?

    init(orderService: OrderService) {
        self.orderService = orderService
        self.orderState = orderService.initialState
        setupSubscriptions()
    }
    
    func togglePaymentMethod(id: String) {
        for index in orderState.order.paymentMethods.indices {
            if orderState.order.paymentMethods[index].id == id {
                orderService.togglePaymentMethod(for: id)
            } else if orderState.order.paymentMethods[index].isActive {
                orderService.togglePaymentMethod(for: orderState.order.paymentMethods[index].id)
            }
        }
    }
    
    func togglePromocode(id: String) {
        orderService.setPromocodeActivity(for: id)
    }
}

private extension PurchaseViewModel {
    func setupSubscriptions() {
        setupPromocodeSubscription()
        setupPaymentMethodsSubscription()
        setupSummarySubscription()
    }
    
    func setupPromocodeSubscription() {
        promocodeSubscription = orderService.promocodePublisher
            .sink(receiveValue: { action in
                switch action {
                case .error(let error):
                    switch error {
                    case .moreThanTwoPromocodes:
                        self.error = .error("Вы не можете использовать более двух промокодов за раз")
                    case .tooBigDiscount:
                        self.error = .error("Сумма текущей скидки не может быть больше суммы заказа")
                    default:
                        self.error = .error("Что-то пошло не так :( Попробуйте снова")
                    }
                case .reload(let promocode):
                    self.updatePromocode(promocode: promocode)
                case .addNew:
                    break
                }
            })
    }
    
    func setupPaymentMethodsSubscription() {
        paymentMethodSubscription = orderService.paymentMethodPublisher
            .sink(receiveValue: { status in
                switch status {
                case .error(let error):
                    switch error {
                    case .moreThanTwoPromocodes:
                        self.error = .error("Вы не можете использовать более двух промокодов за раз")
                    case .tooBigDiscount:
                        self.error = .error("Сумма текущей скидки не может быть больше суммы заказа")
                    default:
                        self.error = .error("Что-то пошло не так :( Попробуйте снова")
                    }
                case .reload(let paymentMethod):
                    self.updatePaymentMethod(paymentMethod: paymentMethod)
                }
            })
    }
    
    func setupSummarySubscription() {
        summarySubscription = orderService.summaryPublisher
            .sink(receiveValue: { summary in
                self.orderState.summary = summary
            })
    }
    func updatePromocode(promocode: Order.Promocode) {
        if let promoIndex = orderState.order.promocodes.firstIndex(where: {$0.id == promocode.id}) {
            orderState.order.promocodes[promoIndex].isActive = promocode.isActive
        }
    }
    
    func updatePaymentMethod(paymentMethod: Order.PaymentMethod) {
        if let methodIndex = orderState.order.paymentMethods.firstIndex(where: {$0.id == paymentMethod.id}) {
            orderState.order.paymentMethods[methodIndex].isActive = paymentMethod.isActive
        }
    }
}
