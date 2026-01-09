//
//  FetchLoansUseCase.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import Foundation

struct FetchLoansUseCase {
    private let repository: LoanRepository

    init(repository: LoanRepository) {
        self.repository = repository
    }

    func execute() -> Result<[Loan], DomainError> {
        do {
            return .success(try repository.fetchAll())
        } catch {
            return .failure(.persistenceFailed("Failed to load loans."))
        }
    }
}
