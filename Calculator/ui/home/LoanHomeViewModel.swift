//
//  LoanHomeViewModel.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import Combine
import CoreData
import SwiftUI

@MainActor
final class LoanHomeViewModel: ObservableObject {
    @Published var loanCards: [LoanCardDisplay] = []
    @Published var message: String?

    private var fetchLoansUseCase: FetchLoansUseCase?
    private var deleteLoansUseCase: DeleteLoansUseCase?
    private let cardDisplayUseCase = LoanCardDisplayUseCase()

    func configure(context: NSManagedObjectContext) {
        let repository = LoanRepository(context: context)
        fetchLoansUseCase = FetchLoansUseCase(repository: repository)
        deleteLoansUseCase = DeleteLoansUseCase(repository: repository)
        loadLoans()
    }

    func loadLoans() {
        guard let fetchLoansUseCase else {
            message = DomainError.missingContext.userMessage
            return
        }

        // Data access and ordering are handled by the domain use case.
        switch fetchLoansUseCase.execute() {
        case .success(let loans):
            message = nil
            loanCards = cardDisplayUseCase.execute(loans: loans)
        case .failure(let error):
            message = error.userMessage
            loanCards = []
        }
    }

    func delete(offsets: IndexSet) {
        guard let deleteLoansUseCase else {
            message = DomainError.missingContext.userMessage
            return
        }

        // Deletion is delegated to the domain use case.
        let ids = offsets.map { loanCards[$0].id }
        switch deleteLoansUseCase.execute(objectIDs: ids) {
        case .success:
            message = nil
            loadLoans()
        case .failure(let error):
            message = error.userMessage
        }
    }
}
