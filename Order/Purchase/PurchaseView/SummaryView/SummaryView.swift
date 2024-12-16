//
//  SummaryView.swift
//  Order
//
//  Created by Sofya Avtsinova on 15.12.2024.
//

import Foundation
import SwiftUI

struct SummaryView: View {
    @ObservedObject var viewModel: SummaryViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 10) {
                HStack {
                    Text("Цена за \(viewModel.productCount) товара")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(viewModel.startPrice) ₽")
                        .font(.body.weight(.medium))
                }
                if !viewModel.baseDiscount.isEmpty {
                    HStack {
                        Text("Скидки")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("-\(viewModel.baseDiscount) ₽")
                            .foregroundStyle(RejectScreenColors.orange)
                            .font(.body.weight(.medium))
                    }
                }
                if !viewModel.promocodeDiscount.isEmpty {
                    HStack {
                        Text("Промокоды")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("-\(viewModel.promocodeDiscount) ₽")
                            .foregroundStyle(RejectScreenColors.green)
                            .font(.body.weight(.medium))
                    }
                }
                if !viewModel.paymentDiscount.isEmpty {
                    HStack {
                        Text("Способ оплаты")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("-\(viewModel.paymentDiscount) ₽")
                            .font(.body.weight(.medium))
                    }
                }
            }
            .foregroundStyle(RejectScreenColors.textGray)
            Divider()
                .background(RejectScreenColors.darkGray)
            
            HStack {
                Text("Итого")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(viewModel.totalPrice) ₽")
            }
            .font(.title3.bold())
            
            Button {
                viewModel.buttonTapped()
            } label: {
                Text("Оплатить")
                    .font(.body.weight(.semibold))
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(RejectScreenColors.orange)
                    .clipShape(.rect(cornerRadius: 12))
            }
            

                Text("Нажимая кнопку «Оформить заказ», Вы соглашаетесь с ")
                    .foregroundStyle(RejectScreenColors.darkGray)
                    .font(.caption)
                +
                Text("Условиями оферты")
                    .foregroundStyle(RejectScreenColors.textGray)
                    .font(.caption)
           
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    init(viewModel: SummaryViewModel) {
        self.viewModel = viewModel
    }
}
