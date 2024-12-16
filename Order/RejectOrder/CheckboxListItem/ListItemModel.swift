//
//  ListItemModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 11.12.2024.
//

import Foundation

enum CheckboxListItemType {
    case none
    case withTextField
}

struct ListItemModel: Identifiable {
    let id = UUID()
    let text: String
    var checked: Bool
    let type: CheckboxListItemType
    
    init(text: String, checked: Bool = false, type: CheckboxListItemType = .none) {
        self.text = text
        self.checked = checked
        self.type = type
    }
}
