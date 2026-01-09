//
//  SaveLoanUseCase.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import Foundation

struct SaveLoanUseCase {
    private let repository: LoanRepository

    init(repository: LoanRepository) {
        self.repository = repository
    }

    func execute(input: LoanCalculatorInput, loanTypeTitle: String?) -> Result<LoanCalculatorSaveResult, DomainError> {
        guard
            let principal = Double(input.principalText.replacingOccurrences(of: ",", with: "")), principal > 0,
            let rate = Double(input.rateText), rate > 0,
            let months = Double(input.monthsText), months > 0
        else {
            return .failure(.invalidInput("Invalid input"))
        }

        do {
            try repository.createLoan(
                principal: principal,
                annualRatePercent: rate,
                tenureMonths: months,
                loanType: loanTypeTitle
            )
            let result = LoanCalculatorSaveResult(
                popupTitle: "Calculation Saved",
                popupMessage: "Your loan calculation is saved and ready to review anytime.",
                primaryButtonTitle: "Okay"
            )
            return .success(result)
        } catch {
            return .failure(.persistenceFailed("Save failed."))
        }
    }
}
