//
//  PDFFileStoring.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import Foundation

protocol PDFFileStoring {
    func save(data: Data, fileName: String) -> Result<URL, DomainError>
}
