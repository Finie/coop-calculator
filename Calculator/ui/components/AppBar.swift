//
//  AppBar.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import SwiftUI
import UIKit

struct AppBar<Leading: View, Center: View, Trailing: View>: View {
    let background: Color
    let leading: Leading
    let center: Center
    let trailing: Trailing

    init(
        background: Color = AppTheme.textPrimary,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder center: () -> Center,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.background = background
        self.leading = leading()
        self.center = center()
        self.trailing = trailing()
    }

    var body: some View {
        ZStack {
            HStack {
                leading
                Spacer()
                trailing
            }
            center
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity)
        .background(background.ignoresSafeArea(edges: .top))
    }

    private var topInset: CGFloat {
        guard
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = scene.windows.first(where: { $0.isKeyWindow })
        else {
            return 0
        }
        return window.safeAreaInsets.top
    }
}
