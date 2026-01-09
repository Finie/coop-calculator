//
//  LoanHomeView.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import SwiftUI
import CoreData

struct LoanHome: View {
    @Environment(\.managedObjectContext) private var context
    
    let onSelect: (Route) -> Void

    @StateObject private var viewModel = LoanHomeViewModel()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                AppBar(
                    background: AppTheme.textPrimary,
                    leading: {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.15))
                            Image(systemName: "person.fill")
                                .foregroundColor(.white)
                        }
                        .frame(width: 44, height: 44)
                        .accessibilityHidden(true)
                    },
                    center: {
                        VStack(spacing: 2) {
                            Text("Hello There!")
                                .font(.title2.weight(.semibold))
                                .foregroundColor(.white)
                            Text("Boost your income today!")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.85))
                        }
                    },
                    trailing: {
                        EmptyView()
                    }
                )

                if viewModel.loanCards.isEmpty {
                    VStack(spacing: 16) {
                        Text("Loan Calculations")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(AppTheme.textPrimary)

                        Image("missing")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)

                        Text("Your saved loan calculations will appear here")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .padding(.top, 32)
                } else {
                    List {
                        ForEach(viewModel.loanCards) { card in
                            Button {
                                onSelect(.loanDetails(card.id))
                            } label: {
                                LoanItem(card: card)
                            }
                            .buttonStyle(.plain)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        }
                        .onDelete { offsets in
                            viewModel.delete(offsets: offsets)
                        }
                    }
                    .listStyle(.plain)
                }
            }

            Button(action: {
                onSelect(.loanCalculator)
            }) {
                Image("calculator")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Circle().fill(AppTheme.textPrimary))
                    .shadow(radius: 4, y: 2)
            }
            .padding(.trailing, 16)
            .padding(.bottom, 16)
        }
        .onAppear { viewModel.configure(context: context) }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
    
}
