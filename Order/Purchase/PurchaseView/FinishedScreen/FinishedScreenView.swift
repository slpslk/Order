//
//  FinishedScreenView.swift
//  Order
//
//  Created by Sofya Avtsinova on 16.12.2024.
//

import Foundation
import SwiftUI

struct FinishedScreenView: View {
    private let viewModel: FinishedScreenViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(RejectScreenColors.textGray)
                }
                .padding()
                Spacer()
            }
            Spacer()
            VStack(spacing: 24) {
                Image(viewModel.imagePath)
                VStack(spacing: 8) {
                    Text(viewModel.title)
                        .font(.title.bold())
                    Text(viewModel.subtitle)
                        .foregroundStyle(RejectScreenColors.darkGray)
                        .multilineTextAlignment(.center)
                }
                Button {
                } label: {
                    Text(viewModel.buttonText)
                        .font(.body.weight(.semibold))
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(RejectScreenColors.orange)
                        .clipShape(.rect(cornerRadius: 12))
                }
                if viewModel.statusButtonVisibility {
                    Button {
                    } label: {
                        Text(viewModel.statusButtonText)
                    }
                    .font(.body.weight(.semibold))
                    .foregroundStyle(RejectScreenColors.orange)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 9)
                }
            }
            .padding(.horizontal, 47)
            Spacer()
        }
        
    }
    
    init(viewModel: FinishedScreenViewModel) {
        self.viewModel = viewModel
    }
}
