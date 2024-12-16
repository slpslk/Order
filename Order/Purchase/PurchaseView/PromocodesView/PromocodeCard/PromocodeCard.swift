//
//  PromocodeCard.swift
//  Order
//
//  Created by Sofya Avtsinova on 14.12.2024.
//

import Foundation
import SwiftUI

struct PromocodeCard: View {
    
    @ObservedObject var viewModel: PromocodeCardViewModel
    
    var body: some View {
        ZStack {
            Toggle(isOn: $viewModel.promocodeModel.isActive) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 4) {
                        Text("\(viewModel.promocodeModel.title)")
                            .foregroundStyle(RejectScreenColors.textGray)
                        Text("-\(viewModel.promocodeModel.percent)%")
                            .font(.callout.weight(.medium))
                            .foregroundStyle(.white)
                            .padding(.vertical, 2)
                            .padding(.horizontal, 6)
                            .background(RejectScreenColors.green)
                            .clipShape(.rect(cornerRadius: 32))
                        Image(systemName: "info.circle")
                            .foregroundStyle(RejectScreenColors.darkGray)
                            .font(.title2)
                    }
                    // поверять и преобразовывать дату
                    Text("По \(viewModel.promocodeModel.endDate)")
                        .foregroundStyle(RejectScreenColors.darkGray)
                }
            }
            .tint(RejectScreenColors.orange)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(RejectScreenColors.lightGray)
            .clipShape(.rect(cornerRadius: 12))
            .onTapGesture {
                viewModel.toggleChecked()
            }
            HStack {
                Circle()
                    .fill(.white)
                    .frame(height: 16)
                    .padding(.leading, -8)
                Spacer()
                Circle()
                    .fill(.white)
                    .frame(height: 16)
                    .padding(.trailing, -8)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    init(viewModel: PromocodeCardViewModel) {
        self.viewModel = viewModel
    }
}
