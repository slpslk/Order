//
//  PurchaseView.swift
//  Order
//
//  Created by Sofya Avtsinova on 12.12.2024.
//

import Foundation
import SwiftUI

struct PurchaseView: View {
    enum Constants {
        static let alertTitle = "Ошибка"
    }
    
    @ObservedObject var viewModel: PurchaseViewModel
    @State private var isAlertPresented = false
    @State private var errorMessage = ""
    
    var body: some View {
        List {
            Section {
                ProductsView(productsInfo: viewModel.orderState.order.products)
            }
            .listRowSeparator(.hidden)
            
            Section {
                PaymentMethodView(viewModel: PaymentMethodViewModel(paymentMethodsInfo: viewModel.orderState.order.paymentMethods, togglePaymentMethod: { id in viewModel.togglePaymentMethod(id: id)}))
            }
            .listRowSeparator(.hidden)
            
            Section {
                PromocodesView(viewModel: PromocodesViewModel(promocodesInfo: viewModel.orderState.order.promocodes, togglePromocode: { id in
                    viewModel.togglePromocode(id: id) }))
            }
            .listRowSeparator(.hidden)
            
            Section {
                SummaryView(viewModel: SummaryViewModel(summaryModel: viewModel.orderState.summary))
            }
            .background(RejectScreenColors.lightGray)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .listSectionSpacing(16)
        .background(RejectScreenColors.lightGray)
        .navigationTitle("Оформление заказа")
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.white, for: .navigationBar)
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text(Constants.alertTitle),
                  message: Text(errorMessage),
                  primaryButton: .cancel(),
                  secondaryButton: .default(Text("OK")))
        }
        .onReceive(viewModel.$error) { error in
            if case let .error(message) = error {
                isAlertPresented = true
                errorMessage = message
            }
        }
    }
}

