//
//  SummaryViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 16.12.2024.
//

import Foundation

class SummaryViewModel: ObservableObject {
    private var summaryModel: Summary
    private let formatter = NumberFormatter()
    
    @Published var productCount: String = ""
    @Published var startPrice: String = ""
    @Published var baseDiscount: String = ""
    @Published var promocodeDiscount: String = ""
    @Published var paymentDiscount: String = ""
    @Published var totalPrice: String = ""
    
    init(summaryModel: Summary) {
        self.summaryModel = summaryModel
        prepareData()
    }
}

private extension SummaryViewModel {
    func prepareData() {
        prepareFormatter()
        prepareNumbers()
    }
    
    func prepareFormatter() {
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
    }
    
    func prepareNumbers() {
        productCount = String(summaryModel.productsCount)
        if let preparedStartPrice = formatter.string(from: NSNumber(value: summaryModel.productsPrice)) {
             startPrice = preparedStartPrice
        }
        
        if summaryModel.baseDiscountAmount > 0, let preparedBaseDiscount = formatter.string(from: NSNumber(value: summaryModel.baseDiscountAmount)) {
            baseDiscount = preparedBaseDiscount
        }
        
        if summaryModel.promocodeAmount > 0, let preparedPromocodeDiscount = formatter.string(from: NSNumber(value: summaryModel.promocodeAmount)) {
            promocodeDiscount = preparedPromocodeDiscount
        }
        
        if summaryModel.paymentDiscountAmount > 0, let preparedPaymentDiscount = formatter.string(from: NSNumber(value: summaryModel.paymentDiscountAmount)) {
            paymentDiscount = preparedPaymentDiscount
        }
        
        if let preparedTotalPrice = formatter.string(from: NSNumber(value: summaryModel.totalPrice)) {
            totalPrice = preparedTotalPrice
        }
    }
}
