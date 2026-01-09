//
//  LoanCalculatorPreviewUseCase.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import Foundation

struct LoanCalculatorPreviewUseCase {
    private let formatter: LoanFormattingService

    init(formatter: LoanFormattingService = LoanFormattingService()) {
        self.formatter = formatter
    }

    func execute(input: LoanCalculatorInput, startDate: Date = Date()) -> LoanCalculatorPreview {
        guard
            let principal = Double(input.principalText.replacingOccurrences(of: ",", with: "")),
            let rate = Double(input.rateText),
            let months = Int(input.monthsText),
            principal > 0,
            rate >= 0,
            months > 0
        else {
            return LoanCalculatorPreview(totalPayableText: formatter.currency(0), repaymentItems: [])
        }

        let breakdown = LoanModel.breakdown(
            for: LoanInput(principal: principal, annualRatePercent: rate, tenureMonths: months)
        )
        let totalPayableText = formatter.currency(breakdown.payable)
        let repaymentItems = repaymentSchedule(
            months: months,
            monthlyPayment: breakdown.monthlyPayment,
            startDate: startDate
        )

        return LoanCalculatorPreview(totalPayableText: totalPayableText, repaymentItems: repaymentItems)
    }

    private func repaymentSchedule(months: Int, monthlyPayment: Double, startDate: Date) -> [RepaymentItemDisplay] {
        let calendar = Calendar.current
        let maxItems = min(2, months)
        let monthlyText = formatter.currency(monthlyPayment)

        return (0..<maxItems).compactMap { index in
            guard let date = calendar.date(byAdding: .month, value: index + 1, to: startDate) else {
                return nil
            }
            let title = "\(formatter.ordinal(index + 1)) installment - \(formatter.date(date))"
            return RepaymentItemDisplay(title: title, amount: "\(monthlyText) KES")
        }
    }
}
