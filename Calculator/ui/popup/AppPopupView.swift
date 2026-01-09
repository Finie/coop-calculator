//
//  AppPopupView.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import Combine
import SwiftUI

struct AppPopupView: View {
    let popup: PopupModel
    let onPrimaryAction: () -> Void
    let onBackdropTap: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture {
                    if popup.dismissOnBackdropTap {
                        onBackdropTap()
                    }
                }

            VStack(spacing: 16) {
                Text(popup.title)
                    .font(.headline)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)

                if let image = popup.image {
                    popupImageView(image)
                }

                Text(popup.message)
                    .font(.body)
                    .foregroundColor(AppTheme.textPrimary)
                    .multilineTextAlignment(.center)

                Button(popup.primaryButtonTitle) {
                    onPrimaryAction()
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.textPrimary)
                .accessibilityLabel(popup.primaryButtonTitle)
            }
            .padding(24)
            .frame(maxWidth: 360)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppTheme.cardBackground)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 16, x: 0, y: 8)
            .padding(.horizontal, 24)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(popup.title). \(popup.message)")
        }
    }

    @ViewBuilder
    private func popupImageView(_ image: PopupModel.PopupImage) -> some View {
        switch image {
        case .image(let image):
            image
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 120)
                .accessibilityHidden(true)
        case .asset(let name):
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 120)
                .accessibilityHidden(true)
        }
    }
}
