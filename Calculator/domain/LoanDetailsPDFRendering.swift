//
//  LoanDetailsPDFRendering.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import Foundation

protocol LoanDetailsPDFRendering {
    func render(details: LoanDetailsDisplay) -> Result<Data, DomainError>
}
