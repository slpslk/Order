//
//  CheckBoxView.swift
//  Order
//
//  Created by Sofya Avtsinova on 11.12.2024.
//

import Foundation
import SwiftUI

struct CheckBoxView: View {
    @Binding var checked: Bool

    var body: some View {
        Image(systemName: checked ? "checkmark.square.fill" : "square")
            .font(.title)
            .foregroundColor(checked ? RejectScreenColors.orange : Color.secondary)
    }
}
