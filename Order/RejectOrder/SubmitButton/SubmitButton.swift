//
//  SubmitButton.swift
//  Order
//
//  Created by Sofya Avtsinova on 12.12.2024.
//

import Foundation
import SwiftUI

struct SubmitButton: View {
    private var text: String
    private let tapHandler: () -> Void
    
    var body: some View {
        Button {
            tapHandler()
        } label: {
            Text(text)
                .font(.body.weight(.semibold))
                .padding(16)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(RejectScreenColors.orange)
                .clipShape(.rect(cornerRadius: 12))
        }
    }
    
    init(text: String, tapHandler: @escaping () -> Void) {
        self.text = text
        self.tapHandler = tapHandler
    }
}
