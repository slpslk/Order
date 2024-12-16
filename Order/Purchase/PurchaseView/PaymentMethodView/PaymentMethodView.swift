//
//  PaymentMethodView.swift
//  Order
//
//  Created by Sofya Avtsinova on 13.12.2024.
//

import Foundation
import SwiftUI

struct PaymentMethodView: View {
    enum Constants {
        static let titleText = "Способ оплаты"
    }
    
    @ObservedObject var viewModel: PaymentMethodViewModel
    
    var body: some View {
        LazyVStack (alignment: .leading, spacing: 16) {
            Text(Constants.titleText)
                .font(.title.bold())
            LazyVStack (spacing: 24) {
                ForEach(viewModel.paymentMethodsInfo) { paymentMethod in
                    let itemViewModel = PaymentItemViewModel(viewState: paymentMethod) { viewModel.toggleSelection(for: paymentMethod)}
                    
                    PaymentItem(viewModel: itemViewModel)
                }
            }
        }
        .padding(.vertical, 14)
    }
    
    init(viewModel: PaymentMethodViewModel) {
        self.viewModel = viewModel
    }
}
