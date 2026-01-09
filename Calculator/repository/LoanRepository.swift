//
//  LoanRepository.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import CoreData

final class LoanRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // CREATE
    func createLoan(
        principal: Double,
        annualRatePercent: Double,
        tenureMonths: Double,
        loanType: String?
    ) throws {
        let loan = Loan(context: context)
        loan.id = UUID()
        loan.principal = principal
        loan.rate = annualRatePercent
        loan.tenureMonths = tenureMonths
        loan.loanType = loanType
        loan.createdAt = Date()

        try context.save()
    }

    // FETCH ALL (newest first)
    func fetchAll() throws -> [Loan] {
        let request: NSFetchRequest<Loan> = Loan.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        return try context.fetch(request)
    }

    // FETCH BY ID (optional helper)
    func fetch(by id: UUID) throws -> Loan? {
        let request: NSFetchRequest<Loan> = Loan.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try context.fetch(request).first
    }

    func fetch(objectID: NSManagedObjectID) throws -> Loan {
        guard let loan = try context.existingObject(with: objectID) as? Loan else {
            throw NSError(domain: "LoanRepository", code: 404, userInfo: nil)
        }
        return loan
    }

    // DELETE
    func delete(_ loan: Loan) throws {
        context.delete(loan)
        try context.save()
    }

    func delete(objectID: NSManagedObjectID) throws {
        let loan = try fetch(objectID: objectID)
        try delete(loan)
    }

}
