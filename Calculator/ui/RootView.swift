//
//  RootView.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//
import SwiftUI
import CoreData

enum Route: Hashable { 
    case loanDetails(NSManagedObjectID)
    case loanCalculator
}


struct RootView: View {
    @State private var path: [Route] = []

    var body: some View {
        NavigationStack(path: $path) {
            LoanHome { destination in
                path.append(destination)
            } 
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .loanCalculator:
                    LoanCalculator() 
                case .loanDetails(let loanID):
                    LoanDetails(loanID: loanID) 
                
                }
            }
        }
        .appPopupHost()
    }
}
