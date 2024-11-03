//
//  File.swift
//  Order
//
//  Created by Sofya Avtsinova on 03.11.2024.
//

import Foundation
import UIKit

extension UIResponder {
    private static weak var currentResponder: UIResponder?

    public static var currentFirstResponder: UIResponder? {
        currentResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return currentResponder
    }

    @objc private func findFirstResponder(_ sender: Any) {
        UIResponder.currentResponder = self
    }
}
