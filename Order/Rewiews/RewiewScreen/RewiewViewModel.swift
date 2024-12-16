//
//  RewiewViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 30.10.2024.
//

import Foundation

final class RewiewViewModel {
    var reloadRow: ((IndexPath) -> Void)?
    var addRow: ((IndexPath) -> Void)?
    var deleteRow: ((IndexPath) -> Void)?
    var reloadTable: (() -> Void)?
    var reloadCellHeight: (() -> Void)?
    
    let product: RewiewTableCellViewModel
    
    lazy var mainCell: CollectionCellViewModel = .init(type: .main(.init(title: "Добавьте фото или видео",
                                                                         subTitle: "Нажмите, чтобы выбрать файлы",
                                                                         tap: nil)))
                      
    lazy var imagePathsCells: [CollectionCellViewModel] = [
        .init(type: .image(.init(imagePath: "rewiewFoto_1",
                                 delete: nil))),
        .init(type: .image(.init(imagePath: "rewiewFoto_2",
                                 delete: nil))),
        .init(type: .image(.init(imagePath: "rewiewFoto_3",
                                 delete: nil))),
        .init(type: .image(.init(imagePath: "rewiewFoto_4",
                                 delete: nil))),
        .init(type: .image(.init(imagePath: "rewiewFoto_5",
                                 delete: nil))),
        .init(type: .image(.init(imagePath: "rewiewFoto_6",
                                 delete: nil))),
        .init(type: .image(.init(imagePath: "rewiewFoto_7",
                                 delete: nil))),
    ]
    
    
    lazy var errorCell: RewiewTableCellViewModel = .init(type: .error(.init(title: "Для продолжения поставьте оценку товару")))

    lazy var rewiewCells: [RewiewTableCellViewModel] = [
        product,
        .init(type: .stars(.init(filledStarsCount: 0, tapStar: { [weak self] starIndex in
                                                        self?.fillStars(starIndex: starIndex)}))),
        .init(type: .addFiles(.init(mainInfo: mainCell,
                                    imagePaths: imagePathsCells,
                                    visibleCellsCount: 1,
                                    reload: { count in
                                        self.changeCount(count: count)}))),
        .init(type: .textField(.init(placeholder: "Достоинства",
                                         isLast: false,
                                         next: { id in
                                             self.nextTextField(id: id)
                                         }))),
        .init(type: .textField(.init(placeholder: "Недостатки",
                                     isLast: false,
                                     next: { id in
                                         self.nextTextField(id: id)
                                     }))),
        .init(type: .textField(.init(placeholder: "Комментарий",
                                     isLast: true,
                                     next: {  id in
                                         self.nextTextField(id: id)
                                     }))),
        .init(type: .checkbox(.init(title: "Оставить отзыв анонимно",
                                    toggle: { [weak self] isChecked in
                                        self?.toggleCheckbox(value: isChecked)
                                    }))),
        .init(type: .sendButton(.init(title: "Отправить",
                                      click: {[weak self] in
                                          self?.clickSendRewiew()
                                      },
                                       warningText: "Перед отправкой отзыва, пожалуйста, ознакомьтесь с ",
                                       highlightedText: "правилами публикации")))
    ]
    
    init(product: RewiewTableCellViewModel) {
        self.product = product
    }
}

private extension RewiewViewModel {
    func fillStars(starIndex: Int) {
        if let starsIndex = rewiewCells.firstIndex(where: { $0.isStars }) {
            if case let .stars(starsInfo) = rewiewCells[starsIndex].type {
                let newStarsInfo = RewiewTableCellViewModel.CellViewModelType.StarsInfo(filledStarsCount: starIndex + 1, tapStar: starsInfo.tapStar)
                if let errorIndex = rewiewCells.firstIndex(where: { $0.isError }) {
                    rewiewCells.remove(at: errorIndex)
                    deleteRow?(IndexPath(row: errorIndex, section: 0))
                }
                
                rewiewCells.remove(at: starsIndex)
                rewiewCells.insert(.init(type: .stars(newStarsInfo)), at: starsIndex)
                reloadRow?(IndexPath(row: starsIndex, section: 0))
            }
        }
    }
    
    func changeCount(count: Int) {
        if let addFilesIndex = rewiewCells.firstIndex(where: { $0.isAddFiles }) {
            if case var .addFiles(addFilesInfo) = rewiewCells[addFilesIndex].type {
                addFilesInfo.visibleCellsCount = count
                
                rewiewCells.remove(at: addFilesIndex)
                rewiewCells.insert(.init(type: .addFiles(addFilesInfo)), at: addFilesIndex)
                reloadCellHeight?()
            }
        }
    }

    func toggleCheckbox(value: Bool) {
        if let checkboxIndex = rewiewCells.firstIndex(where: { $0.isCheckbox }) {
            if case var .checkbox(checkboxInfo) = rewiewCells[checkboxIndex].type {
                checkboxInfo.isChecked = value

                rewiewCells.remove(at: checkboxIndex)
                rewiewCells.insert(.init(type: .checkbox(checkboxInfo)), at: checkboxIndex)
            }
        }
    }
    
    func nextTextField(id: String) {
        if let textFieldIndex = rewiewCells.firstIndex(where: { $0.textFieldMatches(id: id) }) {
            let nextIndex = textFieldIndex + 1
            if nextIndex < rewiewCells.count, case let .textField(textFieldInfo) = rewiewCells[nextIndex].type {
                NotificationCenter.default.post(name: .textFieldShouldBecomeFirstResponder, object: nil, userInfo: [
                    "info": TextFieldNotificationInfo(currentId: textFieldInfo.id)
                ])
            } else {
                NotificationCenter.default.post(name: .textFieldShouldBecomeFirstResponder, object: nil, userInfo: [
                    "info": TextFieldNotificationInfo(currentId: nil)
                ])
            }
        }
    }
    
    func clickSendRewiew() {
        if let starsIndex = rewiewCells.firstIndex(where: { $0.isStars }) {
            if case let .stars(starsInfo) = rewiewCells[starsIndex].type {
                if starsInfo.filledStarsCount == 0 {
                    rewiewCells.insert(errorCell, at: starsIndex + 1)
                    let index = IndexPath(row: starsIndex + 1, section: 0)
                    addRow?(index)
                }
            }
        }
    }
}
