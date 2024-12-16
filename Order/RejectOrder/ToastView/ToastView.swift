//
//  ToastView.swift
//  Order
//
//  Created by Sofya Avtsinova on 12.12.2024.
//

import Foundation
import SwiftUI

struct ToastView: View {
    private let title: String
    @Binding private var show: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Text(title)
                .font(.body.weight(.medium))
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(RejectScreenColors.toastGray)
                .clipShape(.capsule)
        }
        .frame(width: UIScreen.main.bounds.width / 1.5)
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .onTapGesture {
            withAnimation {
                show = false
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    show = false
                }
            }
        }
    }
    
    init(_ title: String, show: Binding<Bool>) {
        self.title = title
        self._show = show
    }
}
