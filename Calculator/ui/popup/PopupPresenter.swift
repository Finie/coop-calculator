//
//  PopupPresenter.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import Combine
import SwiftUI

@MainActor
final class PopupPresenter: ObservableObject {
    @Published var currentPopup: PopupModel?

    func show(_ popup: PopupModel) {
        withAnimation(.easeInOut(duration: 0.2)) {
            currentPopup = popup
        }
    }

    func dismiss() {
        withAnimation(.easeInOut(duration: 0.2)) {
            currentPopup = nil
        }
    }
}
