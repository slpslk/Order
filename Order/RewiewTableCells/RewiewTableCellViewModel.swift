//
//  RewiewTableCellViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 01.11.2024.
//

import Foundation

struct RewiewTableCellViewModel {
    enum CellViewModelType {
        struct SubmitButtonInfo {
            let title: String
            let click: (() -> Void)?
            let warningText: String
            let highlightedText: String
        }
        
        struct ProductInfo {
            let id: String
            let imagePath: String
            let title: String
            let size: Double
            let click: ((String) -> Void)?
        }
        
        struct StarsInfo {
            enum starTitle: Int {
                case none = 0
                case awful = 1
                case bad = 2
                case normal = 3
                case good = 4
                case great = 5
                
                func title() -> String {
                    switch self {
                    case .none:
                        return "Ваша оценка"
                    case .awful:
                        return "Ужасно"
                    case .bad:
                        return "Плохо"
                    case .normal:
                        return "Нормально"
                    case .good:
                        return "Хорошо"
                    case .great:
                        return "Отлично"
                    }
                }
            }
            
            let title: String
            let filledStarsCount: Int
            let tapStar: ((Int) -> Void)?
            
            init(filledStarsCount: Int, tapStar: ((Int) -> Void)?) {
                self.filledStarsCount = filledStarsCount
                self.title = starTitle(rawValue: filledStarsCount)?.title() ?? "Ваша оценка"
                self.tapStar = tapStar
            }
        }
        
        struct ErrorInfo {
            let title: String
        }
        
        struct CheckboxInfo {
            let title: String
            var isChecked: Bool = true
            let toggle: ((Bool) -> Void)?
        }
        
        struct TextFieldInfo {
            let id: String = UUID().uuidString
            let placeholder: String
            let isLast: Bool
            let next: ((String) -> Void)?
        }
        
        struct AddFilesInfo {
            let mainInfo: CollectionCellViewModel
            let imagePaths: [CollectionCellViewModel]
        }

        case product(ProductInfo)
        case stars(StarsInfo)
        case error(ErrorInfo)
        case sendButton(SubmitButtonInfo)
        case checkbox(CheckboxInfo)
        case textField(TextFieldInfo)
        case addFiles(AddFilesInfo)
    }

    var type: CellViewModelType
}

extension RewiewTableCellViewModel {
    var isStars: Bool {
        if case .stars = type { return true }
        return false
    }
    
    var isError: Bool {
        if case .error = type { return true }
        return false
    }
    
    var isAddFiles: Bool {
        if case .addFiles = type { return true }
        return false
    }
    
    var isCheckbox: Bool {
        if case .checkbox = type { return true }
        return false
    }
    
    func productMatches(id: String) -> Bool {
            switch type {
            case .product(let info):
                return info.id == id
            default:
                return false
            }
        }
    func textFieldMatches(id: String) -> Bool {
        switch type {
        case .textField(let info):
            return info.id == id
        default:
            return false
        }
    }
}
