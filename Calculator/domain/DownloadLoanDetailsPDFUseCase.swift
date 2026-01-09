//
//  DownloadLoanDetailsPDFUseCase.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import Foundation

struct DownloadLoanDetailsPDFUseCase {
    private let renderer: LoanDetailsPDFRendering
    private let fileStore: PDFFileStoring

    init(renderer: LoanDetailsPDFRendering, fileStore: PDFFileStoring) {
        self.renderer = renderer
        self.fileStore = fileStore
    }

    func execute(details: LoanDetailsDisplay?) -> Result<URL, DomainError> {
        guard let details else {
            return .failure(.invalidInput("Nothing to download."))
        }

        switch renderer.render(details: details) {
        case .success(let data):
            let fileName = "LoanCalculation-\(Int(Date().timeIntervalSince1970)).pdf"
            return fileStore.save(data: data, fileName: fileName)
        case .failure(let error):
            return .failure(error)
        }
    }
}
