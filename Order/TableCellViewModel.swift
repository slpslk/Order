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
            let toggle: ((String) -> Bool)?
        }
        
        struct TitleInfo {
            let title: String
            let subtitle: String
        }
        
        struct ApplyButtonInfo {
            let title: String
            let image: UIImage?
        }
        
        struct HideButtonInfo {
            let title: String = "Скрыть промокоды"
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
        
        struct OrderButtonInfo {
            let title: String = "Оформить заказ"
            let warningText: String = "Нажимая кнопку «Оформить заказ», Вы соглашаетесь с "
            let highlightedText: String = "Условиями оферты"
        }

        case title(TitleInfo)
        case promocode(PromocodeInfo)
        case applyButton(ApplyButtonInfo)
        case hideButton(HideButtonInfo)
        case totalPrice(TotalPriceInfo)
        case orderButton(OrderButtonInfo)
    }

    var type: CellViewModelType
}
