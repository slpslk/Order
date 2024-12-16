//
//  RejectOrderViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 11.12.2024.
//

import Foundation
import SwiftUI

class RejectOrderViewModel: ObservableObject {
    @Published var listItemsModels: [ListItemModel] = []
    @Published var loading: Bool = false
    @Published var rejectError: Bool = false
    @Published var showToast: Bool = false
    
    init() {
        listItemsModels = [
            .init(text: "Не подходит дата получения"),
            .init(text: "Часть товаров из заказа была отменена"),
            .init(text: "Не получилось применить скидку или промокод"),
            .init(text: "Хочу изменить заказ и оформить заново"),
            .init(text: "Нашелся товар дешевле"),
            .init(text: "Другое", type: .withTextField),
        ]
    }
    
    func toggleSelection(for item: ListItemModel) {
        for index in listItemsModels.indices {
            listItemsModels[index].checked = !item.checked && (listItemsModels[index].id == item.id)
        }
        if rejectError {
            rejectError = false
        }
    }
    
    func submitButtonTapped() {
        if listItemsModels.contains(where: { $0.checked }) {
            rejectError = false
            loading = true
        } else {
            rejectError = true
        }
    }
    
    func clearCheckedItems() {
        for index in listItemsModels.indices {
            listItemsModels[index].checked = false
        }
    }
}
