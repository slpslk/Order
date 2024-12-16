//
//  ProductCard.swift
//  Order
//
//  Created by Sofya Avtsinova on 12.12.2024.
//

import Foundation
import SwiftUI

struct ProductCard: View {
    @ObservedObject var viewModel: ProductCardViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: viewModel.productModel.imagePath)){ image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
            VStack(alignment: .leading, spacing: 8) {
                LazyVStack(alignment: .leading) {
                    Text(viewModel.productModel.title)
                        .foregroundStyle(RejectScreenColors.textGray)
                    HStack (spacing: 1) {
                        Text("\(viewModel.productModel.count) шт.")
                        if let size = viewModel.productModel.size {
                            Text("•")
                                .font(.title)
                            Text("Размер: \(Int(size))")
                        }
                    }
                    .font(.body)
                    .foregroundStyle(RejectScreenColors.darkGray)
                }
                LazyVStack(alignment: .leading) {
                    HStack (spacing: 6) {
                        Text("\(viewModel.startPrice) ₽")
                            .foregroundStyle(RejectScreenColors.darkGray)
                            .strikethrough(true, color: RejectScreenColors.darkGray)
                        if let discount = viewModel.productModel.discount {
                            Text("-\(discount)%")
                                .font(.callout.weight(.medium))
                                .foregroundStyle(RejectScreenColors.orange)
                                .padding(.vertical, 1)
                                .padding(.horizontal, 4)
                                .background(RejectScreenColors.backgroundRed)
                                .clipShape(.rect(cornerRadius: 10))
                        }
                    }
                    Text("\(viewModel.finalPrice) ₽")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(RejectScreenColors.textGray)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    init(viewModel: ProductCardViewModel) {
        self.viewModel = viewModel
    }
}
