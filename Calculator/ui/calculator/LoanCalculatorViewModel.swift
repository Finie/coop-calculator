//
//  LoanCalculatorViewModel.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import Combine
import CoreData
import SwiftUI

@MainActor
final class LoanCalculatorViewModel: ObservableObject {
    @Published var principal = ""
    @Published var rate = ""
    @Published var months = ""
    @Published var loanTypeLabel = "Select Loan Type"
    @Published var isLoanTypeSelected = false
    @Published var loanTypeOptions: [LoanTypeOption] = []
    @Published var repaymentItems: [RepaymentItemDisplay] = []
    @Published var totalPayableText = "0.00"
    @Published var message: String?
    @Published private(set) var popup: PopupModel?

    private var selectedLoanType: LoanTypeOption?
    private var previewUseCase: LoanCalculatorPreviewUseCase?
    private var saveUseCase: SaveLoanUseCase?
    private let loanTypeOptionsUseCase = LoanTypeOptionsUseCase()
    private var cancellables = Set<AnyCancellable>()

    init() {
        Publishers.CombineLatest3($principal, $rate, $months)
            .sink { [weak self] _, _, _ in
                self?.refreshPreview()
            }
            .store(in: &cancellables)
    }

    func configure(context: NSManagedObjectContext) {
        let repository = LoanRepository(context: context)
        previewUseCase = LoanCalculatorPreviewUseCase()
        saveUseCase = SaveLoanUseCase(repository: repository)
        loanTypeOptions = loanTypeOptionsUseCase.execute()
        refreshPreview()
    }

    func selectLoanType(_ option: LoanTypeOption) {
        selectedLoanType = option
        loanTypeLabel = option.title
        isLoanTypeSelected = true
    }

    func save() {
        guard let saveUseCase else {
            message = DomainError.missingContext.userMessage
            return
        }

        let input = LoanCalculatorInput(principalText: principal, rateText: rate, monthsText: months)
        // Validation and persistence live in the domain use case.
        switch saveUseCase.execute(input: input, loanTypeTitle: selectedLoanType?.title) {
        case .success(let result):
            message = nil
            popup = PopupModel(
                title: result.popupTitle,
                message: result.popupMessage,
                image: .asset("success"),
                primaryButtonTitle: result.primaryButtonTitle
            )
            resetInputs()
        case .failure(let error):
            message = error.userMessage
        }
    }

    func clearPopup() {
        popup = nil
    }

    private func refreshPreview() {
        guard let previewUseCase else {
            totalPayableText = "0.00"
            repaymentItems = []
            return
        }

        let input = LoanCalculatorInput(principalText: principal, rateText: rate, monthsText: months)
        // Calculations and formatting are produced by the domain use case.
        let preview = previewUseCase.execute(input: input)
        totalPayableText = preview.totalPayableText
        repaymentItems = preview.repaymentItems
    }

    private func resetInputs() {
        principal = ""
        rate = ""
        months = ""
        selectedLoanType = nil
        loanTypeLabel = "Select Loan Type"
        isLoanTypeSelected = false
        refreshPreview()
    }
}
