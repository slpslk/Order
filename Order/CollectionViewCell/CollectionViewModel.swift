//
//  testViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 03.11.2024.
//

import Foundation

class CollectionViewModel {
    
    private var addItem: ((IndexPath) -> Void)?
    private var deleteItem: ((IndexPath) -> Void)?
    private var reload: (() -> Void)?
    private var mainInfo: CollectionCellViewModel?
    
    private var imagePaths: [CollectionCellViewModel] = []
    
    lazy var addFile: CollectionCellViewModel = .init(type: .addFile(.init(tap: {[weak self] in self?.add()})))
    
    lazy var visibleImagePaths: [CollectionCellViewModel] = []
    
    init() {
        
    }
    
    init(addItem: ( (IndexPath) -> Void)?, deleteItem: ( (IndexPath) -> Void)?, reload: ( () -> Void)?, main: CollectionCellViewModel, images: [CollectionCellViewModel]) {
        self.addItem = addItem
        self.deleteItem = deleteItem
        self.reload = reload
        self.madeData(main: main, images: images)
    }
    
    func madeData(main: CollectionCellViewModel, images: [CollectionCellViewModel]) {
        if case let .main(main) = main.type {
            mainInfo = .init(type: .main(.init(title: main.title,
                                                    subTitle: main.subTitle,
                                                    tap: { [weak self] in
                                                        self?.firstAdd()
                                                    })))
        }
        
        for index in 0..<images.count{
            if case let .image(imageInfo) = images[index].type {
                imagePaths.append(.init(type: .image(.init(imagePath: imageInfo.imagePath,
                                                                delete: {[weak self] id in
                                                                    self?.delete(id: id)
                                                                }))))
            }
        }
        
        visibleImagePaths.append(mainInfo!)
    }
    
    func add() {
        if let newImageIndex = nextImageIndex() {
            visibleImagePaths.insert(imagePaths[newImageIndex], at: visibleImagePaths.count - 1)
            addItem?(IndexPath(item: visibleImagePaths.count - 2, section: 0))
            if visibleImagePaths.count > imagePaths.count {
                visibleImagePaths.removeLast()
                deleteItem?(IndexPath(item: visibleImagePaths.count, section: 0))
            }
        }
    }
    
    func firstAdd() {
        if let newImageIndex = nextImageIndex() {
            visibleImagePaths.removeLast()
            visibleImagePaths.append(imagePaths[newImageIndex])
            visibleImagePaths.append(addFile)
        }
        reload?()
    }
    
    func nextImageIndex() -> Int? {
        for item in 0..<imagePaths.count {
               if case let .image(imageInfo) = imagePaths[item].type {
                   // Считаем, что изображение отсутствует в visibleImagePaths
                   var isVisible = false

                   // Проверяем все видимые изображения
                   for viewImage in 0..<visibleImagePaths.count - 1 {
                       if case let .image(viewImageInfo) = visibleImagePaths[viewImage].type {
                           // Если нашли совпадение, то изображение найдено
                           if imageInfo.id == viewImageInfo.id {
                               isVisible = true
                               break
                           }
                       }
                   }
                   if !isVisible {
                       return item
                   }
               }
           }
           return nil
       }
    
    func delete(id: String) {
        if let imageIndex = visibleImagePaths.firstIndex(where: { $0.imageMatches(id: id) }) {
            visibleImagePaths.remove(at: imageIndex)
            deleteItem?(IndexPath(item: imageIndex, section: 0))
            if !containsAddFile() {
                visibleImagePaths.append(addFile)
                addItem?(IndexPath(item: visibleImagePaths.count - 1, section: 0))
            }
            if visibleImagePaths.count == 1 {
                visibleImagePaths.removeLast()
                deleteItem?(IndexPath(item: visibleImagePaths.count, section: 0))
                visibleImagePaths.append(mainInfo!)
                reload?()
            }
        }
    }
    
    func containsAddFile() -> Bool {
        if visibleImagePaths.first(where: {$0.isAddFile}) != nil {
            return true
        }
        return false
    }
}
