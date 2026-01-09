//
//  LoanDetailsViewModel.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import Combine
import CoreData
import SwiftUI

@MainActor
final class LoanDetailsViewModel: ObservableObject {
    @Published var details: LoanDetailsDisplay?
    @Published var message: String?
    @Published var shareItem: ShareItem?

    private var fetchLoanUseCase: FetchLoanByIDUseCase?
    private let detailsUseCase = LoanDetailsDisplayUseCase()
    private let downloadUseCase = DownloadLoanDetailsPDFUseCase(
        renderer: LoanDetailsPDFRenderer(),
        fileStore: DocumentPDFFileStore()
    )

    func configure(context: NSManagedObjectContext) {
        let repository = LoanRepository(context: context)
        fetchLoanUseCase = FetchLoanByIDUseCase(repository: repository)
    }

    func load(loanID: NSManagedObjectID) {
        guard let fetchLoanUseCase else {
            message = DomainError.missingContext.userMessage
            details = nil
            return
        }

        // Fetching and formatting are handled by domain use cases.
        switch fetchLoanUseCase.execute(objectID: loanID) {
        case .success(let loan):
            message = nil
            details = detailsUseCase.execute(loan: loan)
        case .failure(let error):
            message = error.userMessage
            details = nil
        }
    }

    func downloadPDF() {
        switch downloadUseCase.execute(details: details) {
        case .success(let url):
            shareItem = ShareItem(url: url)
        case .failure(let error):
            message = error.userMessage
        }
    }
}
