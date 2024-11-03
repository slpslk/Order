//
//  File.swift
//  Order
//
//  Created by Sofya Avtsinova on 03.11.2024.
//

import Foundation

extension Notification.Name {
    static let textFieldShouldBecomeFirstResponder = Notification.Name("textFieldShouldBecomeFirstResponder")
}

struct TextFieldNotificationInfo {
    let currentId: String?
}
