//
//  FetchLoanByIDUseCase.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import CoreData
import Foundation

struct FetchLoanByIDUseCase {
    private let repository: LoanRepository

    init(repository: LoanRepository) {
        self.repository = repository
    }

    func execute(objectID: NSManagedObjectID) -> Result<Loan, DomainError> {
        do {
            let loan = try repository.fetch(objectID: objectID)
            return .success(loan)
        } catch {
            let nsError = error as NSError
            if nsError.code == 404 {
                return .failure(.notFound)
            }
            return .failure(.persistenceFailed("Failed to load loan details."))
        }
    }
}
