//
//  LoanCardDisplayUseCase.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import CoreData
import Foundation

struct LoanCardDisplayUseCase {
    private let formatter: LoanFormattingService

    init(formatter: LoanFormattingService = LoanFormattingService()) {
        self.formatter = formatter
    }

    func execute(loans: [Loan]) -> [LoanCardDisplay] {
        loans.map { loan in
            let breakdown = LoanModel.breakdown(
                for: LoanInput(
                    principal: loan.principal,
                    annualRatePercent: loan.rate,
                    tenureMonths: Int(loan.tenureMonths)
                )
            )
            return LoanCardDisplay(
                id: loan.objectID,
                title: loan.loanType ?? "Loan",
                payableText: "\(formatter.currency(breakdown.payable)) KES",
                monthlyText: formatter.currency(breakdown.monthlyPayment),
                interestText: formatter.currency(breakdown.totalInterest)
            )
        }
    }
}
