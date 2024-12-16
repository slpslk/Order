//
//  LoaderView.swift
//  Order
//
//  Created by Sofya Avtsinova on 12.12.2024.
//

import Foundation
import SwiftUI

struct LoaderView: View {
    @Binding private var show: Bool
    
    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white.opacity(0.6))
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        show = false
                    }
                }
            })
    }

    init(show: Binding<Bool>) {
        self._show = show
    }
}
