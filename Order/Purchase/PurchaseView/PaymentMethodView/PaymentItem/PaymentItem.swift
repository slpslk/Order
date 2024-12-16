//
//  PaymentItem.swift
//  Order
//
//  Created by Sofya Avtsinova on 13.12.2024.
//

import Foundation
import SwiftUI

struct PaymentItem: View {
    @ObservedObject var viewModel: PaymentItemViewModel
    
    var body: some View {
        HStack() {
            LazyHStack(spacing: 12) {
                Image(viewModel.viewState.imagePath)
                VStack(alignment: .leading) {
                    HStack (spacing: 4) {
                        Text("\(viewModel.viewState.title)")
                            .font(.body.weight(.medium))
                        if let discount = viewModel.viewState.discount {
                            Text("-\(discount)%")
                                .font(.callout.weight(.medium))
                                .foregroundStyle(.white)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 6)
                                .background(RejectScreenColors.textGray)
                                .clipShape(.rect(cornerRadius: 32))
                        }
                    }
                    Text("\(viewModel.viewState.subtitle)")
                        .foregroundStyle(RejectScreenColors.darkGray)
                }
            }
            Spacer()
            Image(systemName: viewModel.viewState.isActive ? "smallcircle.filled.circle" : "circle")
                .font(.title)
                .foregroundColor(viewModel.viewState.isActive ? RejectScreenColors.orange : RejectScreenColors.darkGray)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .onTapGesture {
            viewModel.toggleChecked()
        }
    }
    
    init(viewModel: PaymentItemViewModel) {
        self.viewModel = viewModel
    }
}
