//
//  LoanCalculator.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//
import Foundation

struct LoanInput {
    let principal: Double
    let annualRatePercent: Double
    let tenureMonths: Int
}

struct LoanBreakdown {
    let monthlyPayment: Double
    let totalInterest: Double
    let payable: Double
}

enum LoanModel {
    static func breakdown(for input: LoanInput) -> LoanBreakdown {
        let P = input.principal
        let n = Double(input.tenureMonths)
        let rMonthly = (input.annualRatePercent / 100.0) / 12.0

        guard n > 0 else {
            return LoanBreakdown(monthlyPayment: 0, totalInterest: 0, payable: 0)
        }

        if rMonthly == 0 {
            let monthly = P / n
            return LoanBreakdown(monthlyPayment: monthly, totalInterest: 0, payable: P)
        }

        let powVal = pow(1 + rMonthly, n)
        let monthly = P * (rMonthly * powVal) / (powVal - 1)
        let totalPaid = monthly * n
        let interest = totalPaid - P

        return LoanBreakdown(monthlyPayment: monthly, totalInterest: interest, payable: totalPaid)
    }
}
