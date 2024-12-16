//
//  InfoView.swift
//  Order
//
//  Created by Sofya Avtsinova on 11.12.2024.
//

import Foundation
import SwiftUI

struct InfoView: View {
    let style: InfoViewStyle
    let text: String
    var backgroundColor: Color
    var iconColor: Color
    var textColor: Color
    
    var body: some View {
        HStack(alignment: .top) {
            Text(text)
                .font(.callout.weight(.medium))
                .foregroundStyle(textColor)
            Spacer(minLength: 16)
            Image(systemName: "exclamationmark.circle.fill")
                .font(.title2)
                .foregroundStyle(iconColor)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .clipShape(.rect(cornerRadius: 12))
    }
    
    init(text: String, style: InfoViewStyle) {
        self.text = text
        self.style = style
        switch style {
        case .warning:
            self.backgroundColor = RejectScreenColors.backgroundYellow
            self.iconColor = RejectScreenColors.yellow
            self.textColor = RejectScreenColors.textGray
        case .danger:
            self.backgroundColor = RejectScreenColors.backgroundRed
            self.iconColor = RejectScreenColors.red
            self.textColor = RejectScreenColors.red
        }
    }
    
    func setupColors() {
        
    }
}
