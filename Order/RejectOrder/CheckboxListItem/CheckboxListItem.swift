//
//  CheckboxListItem.swift
//  Order
//
//  Created by Sofya Avtsinova on 11.12.2024.
//

import Foundation
import SwiftUI

struct CheckboxListItem: View {
    enum Constants {
        static let placeholder = "Опишите проблему"
    }
    @ObservedObject var viewModel: CheckboxListItemViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                CheckBoxView(checked: $viewModel.viewState.checked)
                Text(viewModel.viewState.text)
                    .foregroundStyle(RejectScreenColors.textGray)
                    .font(.body.weight(.medium))
                    .padding(.top, 2)
            }
            .onTapGesture {
                viewModel.toggleChecked()
            }
            if viewModel.viewState.checked && viewModel.viewState.type == .withTextField {
                CustomTextField(placeholder: Constants.placeholder,
                                text: $viewModel.rejectReasonText)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
    }
    
    init(itemModel: ListItemModel, toggleHandler: @escaping () -> Void) {
        self.viewModel = CheckboxListItemViewModel(itemModel: itemModel, 
                                                   toggleHandler: toggleHandler)
    }
}
