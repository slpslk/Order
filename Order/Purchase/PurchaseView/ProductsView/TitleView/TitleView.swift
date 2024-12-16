//
//  TitleView.swift
//  Order
//
//  Created by Sofya Avtsinova on 12.12.2024.
//

import Foundation
import SwiftUI

struct TitleView: View {
    var titleText: String
    var subtitleText: String
    var highlightedText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(titleText)
                .font(.title.bold())
            
            Text(subtitleText)
                .foregroundStyle(RejectScreenColors.darkGray)
            +
            Text(highlightedText)
                .foregroundStyle(RejectScreenColors.orange)
                .font(.body)
        }
    }
}
