//
//  PromocodesScreenViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 19.10.2024.
//

import Foundation
import Combine

final class PromocodesScreenViewModel {
    weak var delegate: TableViewUpdateDelegate?
    var applyButtonHandler: (() -> Void)?
    
    private let orderService: OrderService
    private var orderSubscription: AnyCancellable?
    private var promocodeSubscription: AnyCancellable?
    private var summarySubscription: AnyCancellable?
    
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
    
    init(delegate: TableViewUpdateDelegate? = nil, applyButtonHandler: (() -> Void)? = nil, orderService: OrderService) {
        self.delegate = delegate
        self.applyButtonHandler = applyButtonHandler
        self.orderService = orderService
        madeData(initialState: orderService.initialState)
        setupSubscription()
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
    
    func togglePromo(id: String, value: Bool) {
        orderService.setPromocodeActivity(for: id)
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
        orderService.findPromocodeByTitle(title: title)
    }
    
    func addPromococdeByID(id: String) {
        if let promo = promocodesCells.firstIndex(where: { $0.matches(id: id)}) {
            if case let .promocode(promoInfo) = promocodesCells[promo].type, !promoInfo.isActive {
                orderService.setPromocodeActivity(for: id)
                return
            } else {
                delegate?.showAlert("Промокод уже был активирован")
                return
            }
        }

        addNewPromocode(id: id)
    }
}

private extension PromocodesScreenViewModel {
    var displayedCells: [TableCellViewModel] {
        promocodesCells.filter({ !$0.isHidden })
    }
    
    func setupSubscription() {
        setupPromocodesSubscription()
        setupSummarySubscription()
    }
    
    func setupPromocodesSubscription() {
        promocodeSubscription = orderService.promocodePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { action in
                switch action {
                case .error(let error):
                    switch error {
                    case .moreThanTwoPromocodes:
                        self.delegate?.showAlert("Вы не можете использовать более двух промокодов за раз")
                    case .tooBigDiscount:
                        self.delegate?.showAlert("Сумма текущей скидки не может быть больше суммы заказа")
                    default:
                        break
                    }
                case .reload(let promocode):
                    self.updatePromocodeCell(id: promocode.id, value: promocode.isActive, reload: true)
                case .addNew(let newPromocode):
                    self.addNewPromocodeCell(for: newPromocode)
                }
            })
    }
    
    func setupSummarySubscription() {
        summarySubscription = orderService.summaryPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { summary in
                self.updateTotalPriceCell(promocodeAmount: summary.promocodeAmount, totalPrice: summary.totalPrice)
            })
    }
    
    func madeData(initialState: OrderState) {
        createPromocodeCells(promocodes: initialState.order.promocodes)
        createFooterCells(summary: initialState.summary)
    }
    
    func createPromocodeCells(promocodes: [Order.Promocode]) {
        promocodes.forEach({
            promocodesCells.append(.init(type: .promocode(.init(id: $0.id,
                                                               title: $0.title,
                                                               percent: $0.percent,
                                                               endDate: $0.endDate,
                                                               info: $0.info,
                                                               isActive: $0.isActive,
                                                               toggle: { id, value in self.togglePromo( id: id, value: value)}
                                                              ))))
        })
    }
    
    func createFooterCells(summary: Summary) {
        let productCountString = "Цена за \(summary.productsCount) товара"
        
        footerCells.append(.init(type: .hideButton(.init(click: { [weak self] in
                                                                    self?.hideButtonTapped() },
                                                         isHidden: !(promocodesCells.count > 3)
                                                        ))))
        
        footerCells.append(.init(type: .totalPrice(.init(allPriceTitle: productCountString,
                                                         allPrice: summary.productsPrice,
                                                         discountAmount: summary.baseDiscountAmount,
                                                         promocodeAmount: summary.promocodeAmount,
                                                         paymentAmount: summary.paymentDiscountAmount,
                                                         totalPrice: summary.totalPrice))))
        
        footerCells.append(.init(type: .orderButton(.init(title: "Оформить заказ",
                                                          warningText: "Нажимая кнопку «Оформить заказ», Вы соглашаетесь с ",
                                                          highlightedText: "Условиями оферты"))))
    }
    
    func addNewPromocode(id newPromocodeID: String) {
        orderService.addNewPromocode(id: newPromocodeID)
    }
    
    func addNewPromocodeCell(for newPromocode: Order.Promocode) {
        promocodesCells.insert(.init(type: .promocode(.init(id: newPromocode.id,
                                                            title: newPromocode.title,
                                                            percent: newPromocode.percent,
                                                            endDate: newPromocode.endDate,
                                                            info: newPromocode.info,
                                                            isActive: newPromocode.isActive,
                                                            toggle: { id, value in
                                                              self.togglePromo(id: id, value: value)
                                                            }))),
                               at: promocodesCells.startIndex)
        
        if let firstPromo = allCells.firstIndex(where: { $0.isPromocode }) {
            let indexPath = IndexPath(row: firstPromo, section: 0)
            delegate?.addRow(at: indexPath)
            updateHideButtonVisibility()
            delegate?.showSnackBar()
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
    
    func updateTotalPriceCell(promocodeAmount: Double?, totalPrice: Double) {
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
