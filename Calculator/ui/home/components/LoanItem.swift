//
//  LoanItem.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//
import SwiftUI

struct LoanItem: View {
    let card: LoanCardDisplay

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if !card.title.isEmpty {
                Text(card.title)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            Text(card.payableText)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)

            HStack {
                VStack(spacing: 4) {
                    Text("Monthly")
                        .font(.caption)
                        .foregroundColor(.white)
                    Text(card.monthlyText)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)

                Rectangle()
                    .fill(Color.white.opacity(0.4))
                    .frame(width: 1)

                VStack(spacing: 4) {
                    Text("Interest")
                        .font(.caption)
                        .foregroundColor(.white)
                    Text(card.interestText)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(cardBackground)
                .shadow(color: Color.black.opacity(0.08), radius: 6, y: 2)
        )
    }

    private var cardBackground: AnyShapeStyle {
        switch card.title {
        case "Salary E-Loan":
            return AnyShapeStyle(AppTheme.textPrimary)
        case "Buy Now Pay Later":
            return AnyShapeStyle(AppTheme.textSecondary)
        case "Stock Loan":
            return AnyShapeStyle(AppTheme.accent)
        default:
            return AnyShapeStyle(AppTheme.cardBackground)
        }
    }
}
