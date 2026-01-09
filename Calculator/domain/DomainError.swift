//
//  DomainError.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import Foundation

enum DomainError: Error {
    case missingContext
    case invalidInput(String)
    case persistenceFailed(String)
    case notFound
    case unknown(String)

    var userMessage: String {
        switch self {
        case .missingContext:
            return "Missing context"
        case .invalidInput(let message):
            return message
        case .persistenceFailed(let message):
            return message
        case .notFound:
            return "Loan not found."
        case .unknown(let message):
            return message
        }
    }
}
