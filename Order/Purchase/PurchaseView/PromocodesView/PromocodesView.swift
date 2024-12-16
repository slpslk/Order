//
//  PromocodesView.swift
//  Order
//
//  Created by Sofya Avtsinova on 14.12.2024.
//

import Foundation
import SwiftUI

struct PromocodesView: View {
    enum Constants {
        static let titleText = "Промокоды"
        static let subtitleText = "На один товар можно применить только один промокод"
    }
    @ObservedObject var viewModel: PromocodesViewModel
    
    var body: some View {
        LazyVStack (alignment: .leading, spacing: 16) {
            TitleView(titleText: Constants.titleText,
                      subtitleText: Constants.subtitleText)
            Button {
            } label: {
                HStack(spacing: 10) {
                    Image("promoIcon")
                    Text("Применить промокод")
                        .foregroundStyle(RejectScreenColors.orange)
                        .font(.body.weight(.semibold))
                }
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
            }
            .background(RejectScreenColors.backgroundOrange)
            .clipShape(.rect(cornerRadius: 12))

            VStack(spacing: 10) {
                ForEach(viewModel.promocodesInfo) { promocode in
                    PromocodeCard(viewModel: PromocodeCardViewModel(promocodeModel: promocode, toggleHandler: { viewModel.toggleSelection(id: promocode.id) }))
                }
            }
            
            Button {
            } label: {
                Text("Скрыть промокоды")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(RejectScreenColors.orange)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 9)
            }
        }
        .padding(.vertical, 14)
    }
}


