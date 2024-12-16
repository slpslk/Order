//
//  CustomTextField.swift
//  Order
//
//  Created by Sofya Avtsinova on 12.12.2024.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    private let placeholder: String
    @Binding private var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            TextField("", text: $text)
                .padding(.vertical, 16)
                .padding(.horizontal, 12)
                .background(RejectScreenColors.lightGray, in: .rect(cornerRadius: 12))
            if text.isEmpty {
                Text(placeholder)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 12)
                    .foregroundColor(RejectScreenColors.darkGray)
                    .allowsHitTesting(false)
            }
        }
    }
    
    init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
}
