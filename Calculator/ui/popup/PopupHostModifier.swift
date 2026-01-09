//
//  PopupHostModifier.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import SwiftUI

struct PopupHostModifier: ViewModifier {
    @EnvironmentObject private var presenter: PopupPresenter

    func body(content: Content) -> some View {
        ZStack {
            content
            if let popup = presenter.currentPopup {
                AppPopupView(
                    popup: popup,
                    onPrimaryAction: {
                        popup.primaryAction?()
                        presenter.dismiss()
                    },
                    onBackdropTap: {
                        presenter.dismiss()
                    }
                )
                .transition(.scale(scale: 0.95).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: presenter.currentPopup != nil)
    }
}

extension View {
    func appPopupHost() -> some View {
        modifier(PopupHostModifier())
    }
}
