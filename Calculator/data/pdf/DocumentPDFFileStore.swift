//
//  DocumentPDFFileStore.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import Foundation

struct DocumentPDFFileStore: PDFFileStoring {
    func save(data: Data, fileName: String) -> Result<URL, DomainError> {
        let manager = FileManager.default
        guard let directory = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return .failure(.persistenceFailed("Unable to access documents directory."))
        }

        let fileURL = directory.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL, options: .atomic)
            return .success(fileURL)
        } catch {
            return .failure(.persistenceFailed("Failed to save PDF."))
        }
    }
}
