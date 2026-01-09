//
//  PopupModel.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import SwiftUI

struct PopupModel: Identifiable {
    enum PopupImage {
        case image(Image)
        case asset(String)
    }

    let id = UUID()
    let title: String
    let message: String
    let image: PopupImage?
    let primaryButtonTitle: String
    let primaryAction: (() -> Void)?
    let dismissOnBackdropTap: Bool

    init(
        title: String,
        message: String,
        image: PopupImage? = nil,
        primaryButtonTitle: String,
        primaryAction: (() -> Void)? = nil,
        dismissOnBackdropTap: Bool = true
    ) {
        self.title = title
        self.message = message
        self.image = image
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryAction = primaryAction
        self.dismissOnBackdropTap = dismissOnBackdropTap
    }
}
