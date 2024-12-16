//
//  FinishedScreenViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 16.12.2024.
//

import Foundation

enum FinishedScreenType {
    case successPayed
    case successNotPayed
    case errorNotPayed
    case errorDefault
}

class FinishedScreenViewModel {
    enum Constants {
        static let successImage = "bagSuccess"
        static let errorImage = "paymentError"
        static let successTitle = "Спасибо за заказ!"
        static let errorNotPayedTitle = "Оплата не прошла"
        static let errorDefaultTitle = "Что-то пошло не так..."
        static let successPayedSubtitle = "Заказ успешно оформлен. Вы можете отслеживать его статус в личном кабинете."
        static let successNotPayedSubtitle = "Обратите внимание, что у неоплаченных заказов ограниченный срок хранения"
        static let errorNotPayedSubtitle = "Возможно, были введены неверные данные или произошла ошибка на стороне платежной системы"
        static let errorDefaultSubtitle = "К сожалению, ваш заказ не был создан"
        static let successButtonText = "Продолжить покупки"
        static let errorNotPayedButtonText = "Попробовать еще раз"
        static let errorDefaultButtonText = "На главную"
        static let statusButtonText = "Статус заказа"
    }
    
    private let screenType: FinishedScreenType
    var imagePath = ""
    var title = ""
    var subtitle = ""
    var buttonText = ""
    var statusButtonVisibility = false
    var statusButtonText = ""
    
    init(screenType: FinishedScreenType) {
        self.screenType = screenType
        setupData()
    }
}

private extension FinishedScreenViewModel {
    func setupData() {
        switch screenType {
        case .successPayed:
            imagePath = Constants.successImage
            title = Constants.successTitle
            subtitle = Constants.successPayedSubtitle
            buttonText = Constants.successButtonText
            statusButtonVisibility = true
            statusButtonText = Constants.statusButtonText
        case .successNotPayed:
            imagePath = Constants.successImage
            title = Constants.successTitle
            subtitle = Constants.successNotPayedSubtitle
            buttonText = Constants.successButtonText
            statusButtonVisibility = true
            statusButtonText = Constants.statusButtonText
        case .errorNotPayed:
            imagePath = Constants.errorImage
            title = Constants.errorNotPayedTitle
            subtitle = Constants.errorNotPayedSubtitle
            buttonText = Constants.errorNotPayedButtonText
        case .errorDefault:
            imagePath = Constants.errorImage
            title = Constants.errorDefaultTitle
            subtitle = Constants.errorDefaultSubtitle
            buttonText = Constants.errorDefaultButtonText
            
        }
    }
}
