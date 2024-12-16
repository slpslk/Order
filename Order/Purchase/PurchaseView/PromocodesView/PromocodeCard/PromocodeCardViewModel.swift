//
//  PromocodeCardViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 15.12.2024.
//

import Foundation

class PromocodeCardViewModel: ObservableObject {
    @Published var promocodeModel: Order.Promocode
    @Published var endDateText: String = ""
    private let toggleHandler: () -> Void
    
    init(promocodeModel: Order.Promocode, toggleHandler: @escaping () -> Void) {
        self.promocodeModel = promocodeModel
        self.toggleHandler = toggleHandler
        prepareEndDate()
    }
    
    func toggleChecked() {
        toggleHandler()
    }
}

private extension PromocodeCardViewModel {
    func prepareEndDate() {
        if let date = promocodeModel.endDate {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            
            dateFormatter.dateFormat = "LLLL"
            let monthString = dateFormatter.string(from: date).dropLast() + "я"
            
            dateFormatter.dateFormat = "d"
            let dayString = dateFormatter.string(from: date)
            
            endDateText = "По \(dayString) \(monthString)"
        }
    }
}
