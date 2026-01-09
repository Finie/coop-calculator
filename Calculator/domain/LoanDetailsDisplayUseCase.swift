//
//  LoanDetailsDisplayUseCase.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import Foundation

struct LoanDetailsDisplayUseCase {
    private let formatter: LoanFormattingService

    init(formatter: LoanFormattingService = LoanFormattingService()) {
        self.formatter = formatter
    }

    func execute(loan: Loan) -> LoanDetailsDisplay {
        let breakdown = LoanModel.breakdown(
            for: LoanInput(
                principal: loan.principal,
                annualRatePercent: loan.rate,
                tenureMonths: Int(loan.tenureMonths)
            )
        )

        let detailRows = [
            DetailRowDisplay(title: "Loan Interest (%)", value: "\(loan.rate)%"),
            DetailRowDisplay(title: "Interest", value: "\(formatter.currency(breakdown.totalInterest)) KES"),
            DetailRowDisplay(title: "Loan Amount", value: "\(formatter.currency(loan.principal)) KES"),
            DetailRowDisplay(title: "Loan Period (months)", value: "\(Int(loan.tenureMonths)) Months")
        ]

        let repaymentItems = repaymentSchedule(
            months: max(1, Int(loan.tenureMonths)),
            monthlyPayment: breakdown.monthlyPayment,
            startDate: loan.createdAt ?? Date()
        )

        return LoanDetailsDisplay(
            title: loan.loanType ?? "Loan",
            totalPayableText: formatter.currency(breakdown.payable),
            detailRows: detailRows,
            repaymentItems: repaymentItems
        )
    }

    private func repaymentSchedule(months: Int, monthlyPayment: Double, startDate: Date) -> [RepaymentItemDisplay] {
        let calendar = Calendar.current
        let maxItems = min(2, months)
        let monthlyText = formatter.currency(monthlyPayment)

        return (0..<maxItems).compactMap { index in
            guard let date = calendar.date(byAdding: .month, value: index + 1, to: startDate) else {
                return nil
            }
            let title = "\(formatter.ordinal(index + 1)) instalment - \(formatter.date(date))"
            return RepaymentItemDisplay(title: title, amount: "\(monthlyText) KES")
        }
    }
}
