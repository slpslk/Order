//
//  ProductsView.swift
//  Order
//
//  Created by Sofya Avtsinova on 12.12.2024.
//

import Foundation
import SwiftUI

struct ProductsView: View {
    enum Constants {
        static let titleText = "Состав заказа"
        static let subtitleText = "Вы можете изменить параметры и состав заказа в "
        static let highlightedText = "корзине"
    }
    
    private var productsInfo: [Order.Product]
    
    var body: some View {
        LazyVStack (alignment: .leading, spacing: 16) {
            TitleView(titleText: Constants.titleText,
                      subtitleText: Constants.subtitleText,
                      highlightedText: Constants.highlightedText)
            LazyVStack (spacing: 24) {
                ForEach(productsInfo) { product in
                    ProductCard(viewModel: ProductCardViewModel(productModel: product))
                }
            }
        }
        .padding(.vertical, 14)
    }
    
    init(productsInfo: [Order.Product]) {
        self.productsInfo = productsInfo
    }
}




