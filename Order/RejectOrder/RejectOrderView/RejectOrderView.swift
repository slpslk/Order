//
//  RejectOrderView.swift
//  Order
//
//  Created by Sofya Avtsinova on 11.12.2024.
//

import Foundation
import SwiftUI

struct RejectOrderView: View {
    enum Constants {
        static let errorText = "Пожалуйста, выберите причину"
        static let infoText = "Обычно деньги сразу возвращаются на карту. В некоторых случаях это может занять до 3 рабочих дней."
        static let buttonText = "Отменить заказ"
        static let toastText = "Заказ успешно отменен"
    }
    @ObservedObject var viewModel = RejectOrderViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if viewModel.rejectError {
                InfoView(text: Constants.errorText, style: .danger)
            }
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(viewModel.listItemsModels) { item in
                    CheckboxListItem(itemModel: item) {
                        viewModel.toggleSelection(for: item)
                    }
                }
            }
            
            InfoView(text: Constants.infoText, style: .warning)
            SubmitButton(text: Constants.buttonText) {
                viewModel.submitButtonTapped()
            }
            Spacer()
        }
        .onChange(of: viewModel.loading) {
            if !viewModel.loading {
                viewModel.clearCheckedItems()
                viewModel.showToast = true
            }
        }
        .padding()
        .loader(show: $viewModel.loading)
        .toast(title: Constants.toastText, show: $viewModel.showToast)
        .navigationTitle("Укажите причину отмены")
    }
}
