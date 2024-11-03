//
//  CollectionCellViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 01.11.2024.
//

import Foundation

struct CollectionCellViewModel {
    enum CellViewModelType {
        struct MainInfo {
            let title: String
            let subTitle: String
            let tap: (() -> Void)?
        }
        
        struct AddFileInfo {
            let tap: (() -> Void)?
        }
        
        struct ImageInfo {
            let id: String
            let imagePath: String
            let delete: ((String) -> Void)?
            
            init(id: String = UUID().uuidString, imagePath: String, delete: ((String) -> Void)?) {
                self.id = id
                self.imagePath = imagePath
                self.delete = delete
            }
        }
        
        case main(MainInfo)
        case addFile(AddFileInfo)
        case image(ImageInfo)
    }
    var type: CellViewModelType
}

extension CollectionCellViewModel {
    var isAddFile: Bool {
        if case .addFile = type { return true }
        return false
    }
    func imageMatches(id: String) -> Bool {
            switch type {
            case .image(let info):
                return info.id == id
            default:
                return false
            }
        }
}
