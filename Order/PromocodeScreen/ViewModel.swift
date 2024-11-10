//
//  ViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 19.10.2024.
//

import Foundation

final class ViewModel {
    weak var delegate: TableViewUpdateDelegate?
    var applyButtonHandler: (() -> Void)?
    
    lazy var products: [Order.Product] = [
        .init(price: 1200, title: "Товар 1"),
        .init(price: 5800, title: "Товар 2"),
        .init(price: 7500, title: "Товар 3"),
    ]
    
    lazy var promocodes: [Order.Promocode] = [
        .init(title: "HELLOHELLOHELLOHELLOHELLOHELLOHELLOHELLOHELLOHELLOHELLO",
              percent: 70,
              endDate: nil,
              info: "Промокод действует на первый заказ в приложении",
              active: false),
        .init(title: "NSK2024",
              percent: 20,
              endDate: Date(timeIntervalSince1970: 1732924800),
              info: "Промокод действует для заказов от 3000 ₽",
              active: false),
        .init(title: "New Year",
              percent: 15,
              endDate: Date(timeIntervalSince1970: 1735603200),
              info: nil,
              active: true),
//        .init(title: "New Year",
//              percent: 15,
//              endDate: Date(timeIntervalSince1970: 1735603200),
//              info: nil,
//              active: true),
     ]
    
    lazy var availablePromocodes: [Order.Promocode] = [
        .init(title: "Secret50",
              percent: 50,
              endDate: nil,
              info: "Промокод действует на первый заказ в приложении",
              active: false),
        .init(title: "v8dskutevs76",
              percent: 15,
              endDate: Date(timeIntervalSince1970: 1735603200),
              info: nil,
              active: false),
    ]
    
    lazy var orderInfo = Order(screenTitle: "Промокоды",
                               promocodes: promocodes,
                               availableForActive: availablePromocodes,
                               products: products,
                               paymentDiscount: 500,
                               baseDiscount: 500)
    
    
    lazy var headerCells: [TableCellViewModel] = [
        .init(type: .title(.init(title: "Промокоды",
                                 subtitle: "На один товар можно применить только один промокод"))),
        .init(type: .applyButton(.init(title: "Применить промокод", click: applyButtonHandler))),
    ]
    
    lazy var promocodesCells: [TableCellViewModel] = []
    lazy var footerCells: [TableCellViewModel] = []
    
    var allCells: [TableCellViewModel] {
        headerCells + displayedCells + footerCells
    }
    
    func changeDisplayedCells(_ cellsIsHidden: Bool) {
        let shownCells = 3
        
        for cell in shownCells..<promocodesCells.count {
            if case var .promocode(promoInfo) = promocodesCells[cell].type {
                promoInfo.isHidden = cellsIsHidden
                
                promocodesCells.remove(at: cell)
                promocodesCells.insert(.init(type: .promocode(promoInfo)), at: cell)
            }
        }

    }
    
    func madeData()  {
        createPromocodeCells()
        createFooterCells()
    }
    
    func togglePromo(id: String, value: Bool) {
        if let promoIndex = orderInfo.promocodes.firstIndex(where: { $0.id == id}) {
            orderInfo.promocodes[promoIndex].active.toggle()
            if activePromocodesCount > 2 {
                orderInfo.promocodes[promoIndex].active.toggle()
                delegate?.showAlert("Вы не можете использовать более двух промокодов за раз")
                updatePromocodeCell(id: id, value: !value, reload: true)
                return
            }
            if totalPrice <= 0 {
                orderInfo.promocodes[promoIndex].active.toggle()
                delegate?.showAlert("Сумма текущей скидки не может быть больше суммы заказа")
                updatePromocodeCell(id: id, value: !value, reload: true)
                return
            }
            updatePromocodeCell(id: id, value: value, reload: false)
            updateTotalPriceCell()
        }

        if let availablePromoIndex = orderInfo.availableForActive?.firstIndex(where: { $0.id == id}) {
            orderInfo.availableForActive?[availablePromoIndex].active.toggle()
            if activePromocodesCount > 2 {
                orderInfo.availableForActive?[availablePromoIndex].active.toggle()
                delegate?.showAlert("Вы не можете использовать более двух промокодов за раз")
                updatePromocodeCell(id: id, value: !value, reload: true)
                return
            }
            if totalPrice <= 0 {
                orderInfo.availableForActive?[availablePromoIndex].active.toggle()
                delegate?.showAlert("Сумма текущей скидки не может быть больше суммы заказа")
                updatePromocodeCell(id: id, value: !value, reload: true)
                return
            }
            updatePromocodeCell(id: id, value: value, reload: false)
            updateTotalPriceCell()
        }
    }
    
    func hideButtonTapped() {
        if let buttonIndex = footerCells.firstIndex(where: { $0.isHideButton }) {
            if case var .hideButton(buttonInfo) = footerCells[buttonIndex].type {
                delegate?.changeShowingCells()
                let hiddenCellsCount = promocodesCells.count - displayedCells.count
                var newTitle = "Еще \(hiddenCellsCount) "
                switch hiddenCellsCount {
                case 1:
                    newTitle += "промокод"
                case 2,3,4:
                    newTitle += "промокода"
                default:
                    newTitle += "промокодов"
                }
                buttonInfo.title = hiddenCellsCount == 0 ? "Скрыть промокоды" : newTitle
                
                footerCells.remove(at: buttonIndex)
                footerCells.insert(.init(type: .hideButton(buttonInfo)), at: buttonIndex)
            }
        }
        delegate?.reloadTable()
    }
    
    func findPromocodeByTitle(title: String) -> String? {
        if let avaliablePromocode = orderInfo.availableForActive?.first(where: {
            title == $0.title
        }){
            return avaliablePromocode.id
        } else {
            return nil
        }
    }
    
    func addPromococdeByID(id: String) {
        guard let availableForActive = orderInfo.availableForActive else{
            return
        }
        
        if let promo = promocodesCells.firstIndex(where: { $0.matches(id: id)}) {
            if case let .promocode(promoInfo) = promocodesCells[promo].type, !promoInfo.isActive {
                if let avaliablePromoIndex = availableForActive.firstIndex(where: {
                    id == $0.id
                }) {
                    orderInfo.availableForActive?[avaliablePromoIndex].active.toggle()
                    
                    updatePromocodeCell(id: id, value: !promoInfo.isActive, reload: true)
                    updateTotalPriceCell()
                    delegate?.showSnackBar()
                    return
                }
            } else {
                delegate?.showAlert("Промокод уже был активирован")
                return
            }
        }
        
        if let newPromocodeIndex = availableForActive.firstIndex(where: {
            id == $0.id
        }) {
            addNewPromocode(at: newPromocodeIndex)
        }
    }
    
    func checkData() throws {
        guard productsCount != 0 else{
            throw OrderError.zeroProducts
        }
        
        try orderInfo.products.forEach {
            if $0.price <= 0 {
                throw OrderError.zeroProductPrice
            }
        }
        
        try orderInfo.promocodes.forEach{
            if $0.percent <= 0 || $0.percent > 100 {
                throw OrderError.dataError
            }
        }

        if orderInfo.promocodes.filter({$0.active}).count > 2 {
            throw OrderError.moreThanTwoPromocodes
        }
        
        if totalPrice <= 0 {
            throw OrderError.tooBigDiscount
        }
    }
}

private extension ViewModel {
    var promocodePercent: Int {
        let basePromocodes = orderInfo.promocodes.reduce(0) { sum, promocode in
            promocode.active ? sum + promocode.percent : sum
        }
        let avaliablePromocodes = orderInfo.availableForActive?.reduce(0) { sum, promocode in
            promocode.active ? sum + promocode.percent : sum
        }
        
        return basePromocodes + (avaliablePromocodes ?? 0)
    }
    
    var activePromocodesCount: Int {
        let baseCount = orderInfo.promocodes.filter({$0.active}).count
        let avaliableCount = orderInfo.availableForActive?.filter({$0.active}).count
        
        return baseCount + (avaliableCount ?? 0)
    }
    
    var productsCount: Int {
        orderInfo.products.count
    }
    
    var productsPrice: Double {
        orderInfo.products.reduce(0,{$0 + $1.price})
    }
    
    var promocodeAmount: Double? {
        promocodePercent > 0 ? productsPrice * Double(promocodePercent)/100 : nil
    }
    
    var totalPrice: Double {
        productsPrice - (orderInfo.baseDiscount ?? 0) - (orderInfo.paymentDiscount ?? 0) - (promocodeAmount ?? 0)
    }
    
    var displayedCells: [TableCellViewModel] {
        promocodesCells.filter({ !$0.isHidden })
    }
    
    func createPromocodeCells() {
        orderInfo.promocodes.forEach({
            promocodesCells.append(.init(type: .promocode(.init(id: $0.id,
                                                               title: $0.title,
                                                               percent: $0.percent,
                                                               endDate: $0.endDate,
                                                               info: $0.info,
                                                               isActive: $0.active,
                                                               toggle: { id, value in self.togglePromo( id: id, value: value)}
                                                              ))))
        })
    }
    
    func createFooterCells() {
        let productCountString = "Цена за \(productsCount) товара"
        
        footerCells.append(.init(type: .hideButton(.init(click: { [weak self] in
                                                                    self?.hideButtonTapped() },
                                                         isHidden: !(promocodesCells.count > 3)
                                                        ))))
        
        footerCells.append(.init(type: .totalPrice(.init(allPriceTitle: productCountString,
                                                            allPrice: productsPrice,
                                                            discountAmount: orderInfo.baseDiscount,
                                                            promocodeAmount: promocodeAmount,
                                                            paymentAmount: orderInfo.paymentDiscount,
                                                            totalPrice: totalPrice))))
        
        footerCells.append(.init(type: .orderButton(.init(title: "Оформить заказ",
                                                          warningText: "Нажимая кнопку «Оформить заказ», Вы соглашаетесь с ",
                                                          highlightedText: "Условиями оферты"))))
    }
    
    func addNewPromocode(at newPromocodeIndex: Int) {
        if activePromocodesCount == 2 {
            if let lastActivePromoIndex = orderInfo.promocodes.lastIndex(where: {$0.active}) {
                orderInfo.promocodes[lastActivePromoIndex].active.toggle()
                orderInfo.availableForActive?[newPromocodeIndex].active = true
                if totalPrice <= 0 {
                    orderInfo.availableForActive?[newPromocodeIndex].active = false
                    orderInfo.promocodes[lastActivePromoIndex].active.toggle()
                    delegate?.showAlert("Сумма текущей скидки не может быть больше суммы заказа")
                    return
                }
                let lastActivePromo = orderInfo.promocodes[lastActivePromoIndex]
                updatePromocodeCell(id: lastActivePromo.id,
                                    value: lastActivePromo.active,
                                    reload: true)
            }
        } else {
            orderInfo.availableForActive?[newPromocodeIndex].active = true
            if totalPrice <= 0 {
                orderInfo.availableForActive?[newPromocodeIndex].active = false
                delegate?.showAlert("Сумма текущей скидки не может быть больше суммы заказа")
                return
            }
        }
        if let newPromocode = orderInfo.availableForActive?[newPromocodeIndex] {
            promocodesCells.insert(.init(type: .promocode(.init(id: newPromocode.id,
                                                                title: newPromocode.title,
                                                                percent: newPromocode.percent,
                                                                endDate: newPromocode.endDate,
                                                                info: newPromocode.info,
                                                                isActive: newPromocode.active,
                                                                toggle: { id, value in self.togglePromo( id: id, value: value)}
                                                               )))
                                   , at: promocodesCells.startIndex)
            
            if let firstPromo = allCells.firstIndex(where: { $0.isPromocode }) {
                let indexPath = IndexPath(row: firstPromo, section: 0)
                delegate?.addRow(at: indexPath)
                updateHideButtonVisibility()
                updateTotalPriceCell()
                delegate?.showSnackBar()
            }
        }
    }
    
    func updateHideButtonVisibility() {
        if promocodesCells.count > 3 {
            if let cellIndex = footerCells.firstIndex(where: { $0.isHideButton }) {
                if case var .hideButton(buttonInfo) = footerCells[cellIndex].type, buttonInfo.isHidden {
                    buttonInfo.isHidden = !buttonInfo.isHidden
                    footerCells.remove(at: cellIndex)
                    footerCells.insert(.init(type: .hideButton(buttonInfo)), at: cellIndex)
                    
                    if let globalIndex = allCells.firstIndex(where: { $0.isHideButton }) {
                        reloadRow(at: globalIndex)
                    }
                }
            }
        }
    }
    
    func updateTotalPriceCell() {
        if let totalPriceIndex = footerCells.firstIndex(where: { $0.isTotalPrice }) {
                if case var .totalPrice(totalInfo) = footerCells[totalPriceIndex].type {
                    totalInfo.totalPrice = totalPrice
                    totalInfo.promocodeAmount = promocodeAmount
                    
                    footerCells.remove(at: totalPriceIndex)
                    footerCells.insert(.init(type: .totalPrice(totalInfo)), at: totalPriceIndex)
                    
                    if let globalIndex = allCells.firstIndex(where: { $0.isTotalPrice }) {
                        reloadRow(at: globalIndex)
                    }
                }
            }
        }
    
    func updatePromocodeCell(id: String, value: Bool, reload: Bool) {
        if let cellIndex = promocodesCells.firstIndex(where: { $0.matches(id: id) }) {
            if case var .promocode(promoInfo) = promocodesCells[cellIndex].type {
                promoInfo.isActive = value
                promocodesCells.remove(at: cellIndex)
                promocodesCells.insert(.init(type: .promocode(promoInfo)), at: cellIndex)

                if reload, let globalIndex = allCells.firstIndex(where: { $0.matches(id: id) }) {
                    reloadRow(at: globalIndex)
                }
            }
        }
    }
    
    func updateHideButtonCell(value: Bool, reload: Bool) {
        if let cellIndex = footerCells.firstIndex(where: { $0.isHideButton }) {
            if case var .hideButton(buttonInfo) = footerCells[cellIndex].type {
                buttonInfo.isHidden = value
                footerCells.remove(at: cellIndex)
                footerCells.insert(.init(type: .hideButton(buttonInfo)), at: cellIndex)
                
                if reload, let globalIndex = allCells.firstIndex(where: { $0.isHideButton }) {
                    reloadRow(at: globalIndex)
                }
            }
        }
    }
    
    func reloadRow(at globalIndex: Int) {
        let indexPath = IndexPath(row: globalIndex, section: 0)
        delegate?.reloadRow(at: indexPath)
    }
    
}
