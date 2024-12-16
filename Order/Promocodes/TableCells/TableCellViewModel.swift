//
//  TableCellViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 19.10.2024.
//

import Foundation
import UIKit


struct TableCellViewModel {
    enum CellViewModelType {
        struct PromocodeInfo {
            let id: String
            let title: String
            let percent: Int
            let endDate: Date?
            let info: String?
            var isActive: Bool
            let toggle: ((String, Bool) -> Void)?
            var isHidden: Bool = false
        }
        
        struct TitleInfo {
            let title: String
            let subtitle: String
        }
        
        struct ApplyButtonInfo {
            let title: String
            let click: (() -> Void)?
        }
        
        struct HideButtonInfo {
            var title: String = "Скрыть промокоды"
            let click: (() -> Void)?
            var isHidden: Bool = true
        }
        
        struct TotalPriceInfo {
            let allPriceTitle: String
            let discountAmountTitle: String = "Скидки"
            let promocodeAmountTitle: String = "Промокоды"
            let paymentAmountTitle: String = "Способ оплаты"
            let totalPriceTitle: String = "Итого"
            
            let allPrice: Double
            let discountAmount: Double?
            var promocodeAmount: Double?
            let paymentAmount: Double?
            var totalPrice: Double
        }
        
        struct SubmitButtonInfo {
            let title: String
            let warningText: String
            let highlightedText: String
        }

        case title(TitleInfo)
        case promocode(PromocodeInfo)
        case applyButton(ApplyButtonInfo)
        case hideButton(HideButtonInfo)
        case totalPrice(TotalPriceInfo)
        case orderButton(SubmitButtonInfo)
    }

    var type: CellViewModelType
}

extension TableCellViewModel {
    var isHidden: Bool {
            switch type {
            case .promocode(let info):
                return info.isHidden
            default:
                return false
            }
        }
    
    var isHideButton: Bool {
        if case .hideButton = type { return true }
        return false
    }
    
    var isPromocode: Bool {
        if case .promocode = type { return true }
        return false
    }
    
    var isTotalPrice: Bool {
        if case .totalPrice = type { return true }
        return false
    }
    
    func matches(id: String) -> Bool {
            switch type {
            case .promocode(let info):
                return info.id == id
            default:
                return false
            }
        }
}
