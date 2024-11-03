//
//  ProductsViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 29.10.2024.
//

import Foundation

class ProductsViewModel {
    lazy var products: [RewiewProduct] = [
        .init(imagePath: "ring_1",
              title: "Золотое плоское обручальное кольцо 4 мм",
              size: 17),
        .init(imagePath: "ring_2",
              title: "Золотое плоское обручальное кольцо 4 мм",
              size: 17),
        .init(imagePath: "ring_3",
              title: "Золотое плоское обручальное кольцо 4 мм",
              size: 17),
        .init(imagePath: "ring_4",
              title: "Золотое плоское обручальное кольцо 4 мм",
              size: 17),
    ]
    
    lazy var productsCells: [RewiewTableCellViewModel] = []
    
    var productTap: ((RewiewTableCellViewModel) -> Void)?
    
    func showProducts() {
        products.forEach({
            productsCells.append(.init(type: .product(.init(id: $0.id,
                                                            imagePath: $0.imagePath,
                                                            title: $0.title,
                                                            size: $0.size,
                                                            click: {id in self.productTapHandler(id:id)}
                                                           ))))
        })
    }
}

private extension ProductsViewModel {
    func findProductByID(id: String) -> RewiewTableCellViewModel? {
        if let product = productsCells.first(where: { $0.productMatches(id: id) }) {
            return product
        } else {
            return nil
        }
    }
    
    func productTapHandler(id: String) {
        if let product = findProductByID(id: id) {
            productTap?(product)
        }
    }
}
