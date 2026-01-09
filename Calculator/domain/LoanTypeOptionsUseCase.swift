//
//  LoanTypeOptionsUseCase.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import Foundation

struct LoanTypeOptionsUseCase {
    func execute() -> [LoanTypeOption] {
        [
            LoanTypeOption(id: "salary", title: "Salary E-Loan"),
            LoanTypeOption(id: "later", title: "Buy Now Pay Later"),
            LoanTypeOption(id: "stock", title: "Stock Loan")
        ]
    }
}
