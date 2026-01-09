//
//  LoanDisplayModels.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import CoreData
import Foundation

struct LoanTypeOption: Identifiable {
    let id: String
    let title: String
}

struct LoanCalculatorInput {
    let principalText: String
    let rateText: String
    let monthsText: String
}

struct RepaymentItemDisplay: Identifiable {
    let id = UUID()
    let title: String
    let amount: String
}

struct LoanCalculatorPreview {
    let totalPayableText: String
    let repaymentItems: [RepaymentItemDisplay]
}

struct LoanCalculatorSaveResult {
    let popupTitle: String
    let popupMessage: String
    let primaryButtonTitle: String
}

struct LoanCardDisplay: Identifiable {
    let id: NSManagedObjectID
    let title: String
    let payableText: String
    let monthlyText: String
    let interestText: String
}

struct DetailRowDisplay: Identifiable {
    let id = UUID()
    let title: String
    let value: String
}

struct LoanDetailsDisplay {
    let title: String
    let totalPayableText: String
    let detailRows: [DetailRowDisplay]
    let repaymentItems: [RepaymentItemDisplay]
}
