//
//  OrderError.swift
//  Order
//
//  Created by Sofya Avtsinova on 19.10.2024.
//

import Foundation

enum OrderError: Error {
    case zeroProducts
    case zeroProductPrice
    case tooBigDiscount
    case moreThanTwoPromocodes
    case dataError
}
