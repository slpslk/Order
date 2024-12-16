//
//  LoaderModifier.swift
//  Order
//
//  Created by Sofya Avtsinova on 12.12.2024.
//

import Foundation
import SwiftUI

struct LoaderModifier : ViewModifier {
    @Binding private var show: Bool

    func body(content: Content) -> some View {
        ZStack {
            content

            if show {
                LoaderView(show: $show)
            }
        }
    }
    
    init(show: Binding<Bool>) {
        self._show = show
    }
}

extension View {
    func loader(show: Binding<Bool>) -> some View {
        self.modifier(LoaderModifier(show: show))
    }
}
