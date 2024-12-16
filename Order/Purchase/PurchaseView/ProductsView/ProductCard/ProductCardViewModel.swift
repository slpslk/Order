//
//  ProductCardViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 12.12.2024.
//

import Foundation

class ProductCardViewModel: ObservableObject {
    let productModel: Order.Product
    let formatter = NumberFormatter()
    @Published var startPrice: String = ""
    @Published var finalPrice: String = ""
    
    init(productModel: Order.Product) {
        self.productModel = productModel
        prepareData()
    }
}

private extension ProductCardViewModel {
    func prepareData() {
        prepareFormatter()
        preparePrices()
    }
    
    func prepareFormatter() {
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
    }
    
    func calculatePrice() -> Double{
        if let discount = productModel.discount {
            return (productModel.price * Double(100 - discount)) / 100
        } else {
            return productModel.price
        }
    }
    
    func preparePrices() {
        let calculatedFinalPrice = calculatePrice()
        if let preparedStartPrice = formatter.string(from: NSNumber(value: productModel.price)) {
             startPrice = preparedStartPrice
        }
        
        if let preparedFinalPrice = formatter.string(from: NSNumber(value: calculatedFinalPrice)) {
            finalPrice = preparedFinalPrice
        }
    }
}
