//
//  ToastModifier.swift
//  Order
//
//  Created by Sofya Avtsinova on 12.12.2024.
//

import Foundation
import SwiftUI

struct ToastModifier : ViewModifier {
    private let title: String

    @Binding private var show: Bool

    func body(content: Content) -> some View {
        ZStack {
            content

            if show {
                ToastView(title, show: $show)
            }
        }
    }
    
    init(title: String, show: Binding<Bool>) {
        self.title = title
        self._show = show
    }
}

extension View {
    func toast(title: String, show: Binding<Bool>) -> some View {
        self.modifier(ToastModifier(title: title, show: show))
    }
}
