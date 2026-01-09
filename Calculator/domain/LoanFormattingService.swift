//
//  LoanFormattingService.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import Foundation

struct LoanFormattingService {
    private let currencyFormatter: NumberFormatter
    private let dateFormatter: DateFormatter

    init() {
        let currency = NumberFormatter()
        currency.numberStyle = .decimal
        currency.minimumFractionDigits = 2
        currency.maximumFractionDigits = 2
        currencyFormatter = currency

        let date = DateFormatter()
        date.dateFormat = "dd MMM yyyy"
        dateFormatter = date
    }

    func currency(_ value: Double) -> String {
        currencyFormatter.string(from: NSNumber(value: value)) ?? "0.00"
    }

    func date(_ value: Date) -> String {
        dateFormatter.string(from: value)
    }

    func ordinal(_ value: Int) -> String {
        let suffix: String
        switch value % 10 {
        case 1 where value % 100 != 11: suffix = "st"
        case 2 where value % 100 != 12: suffix = "nd"
        case 3 where value % 100 != 13: suffix = "rd"
        default: suffix = "th"
        }
        return "\(value)\(suffix)"
    }
}
