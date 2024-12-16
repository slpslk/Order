//
//  CheckboxListItemViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 11.12.2024.
//

import Foundation
import SwiftUI

class CheckboxListItemViewModel: ObservableObject {
    private let toggleHandler: () -> Void

    @Published var rejectReasonText: String = ""
    @Published var viewState: ListItemModel
    
    init(itemModel: ListItemModel, toggleHandler: @escaping () -> Void) {
        self.viewState = itemModel
        self.toggleHandler = toggleHandler
    }
    
    func toggleChecked() {
        toggleHandler()
    }
}
