//
//  ApplyPromocodeViewModel.swift
//  Order
//
//  Created by Sofya Avtsinova on 23.10.2024.
//

import Foundation
import UIKit

class ApplyPromocodeViewModel {
    var promocodeTitle: String = ""
    var applyPromocode: ((String) -> Void)?
    var findPromocode: ((String) -> String?)?
}
