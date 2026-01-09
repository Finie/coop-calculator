//
//  DeleteLoansUseCase.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import CoreData
import Foundation

struct DeleteLoansUseCase {
    private let repository: LoanRepository

    init(repository: LoanRepository) {
        self.repository = repository
    }

    func execute(objectIDs: [NSManagedObjectID]) -> Result<Void, DomainError> {
        do {
            for id in objectIDs {
                try repository.delete(objectID: id)
            }
            return .success(())
        } catch {
            return .failure(.persistenceFailed("Delete failed."))
        }
    }
}
