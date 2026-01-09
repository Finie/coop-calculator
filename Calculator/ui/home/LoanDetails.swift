//
//  LoanDetails.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//
import SwiftUI
import CoreData

struct LoanDetails: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss

    let loanID: NSManagedObjectID
    @StateObject private var viewModel = LoanDetailsViewModel()

    var body: some View {
        VStack(spacing: 0) {
            AppBar(
                background: AppTheme.textPrimary,
                leading: {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)
                    }
                    .accessibilityLabel("Back")
                },
                center: {
                    Text("Loan Calculation")
                        .font(.headline)
                        .foregroundColor(.white)
                },
                trailing: {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)
                    }
                    .accessibilityLabel("Close")
                }
            )

            ScrollView {
                if let details = viewModel.details {
                    VStack(spacing: 26) {
                        VStack(spacing: 6) {
                            Text(details.title)
                                .font(.title3.weight(.semibold))
                                .foregroundColor(AppTheme.textPrimary)
                            Text("Total Amount Payable (KES)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(details.totalPayableText)
                                .font(.system(size: 40, weight: .semibold))
                                .foregroundColor(AppTheme.accent)
                                .minimumScaleFactor(0.8)
                        }
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)

                        VStack(spacing: 14) {
                            ForEach(details.detailRows) { row in
                                detailRow(title: row.title, value: row.value)
                            }
                        }
                        .padding(.horizontal, 24)

                        Divider()
                            .padding(.horizontal, 24)

                        VStack(alignment: .leading, spacing: 14) {
                            Text("Repayment Schedule")
                                .font(.title3.weight(.semibold))
                                .foregroundColor(AppTheme.textPrimary)

                            ForEach(details.repaymentItems) { item in
                                HStack {
                                    Text(item.title)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(item.amount)
                                        .fontWeight(.semibold)
                                        .foregroundColor(AppTheme.textPrimary)
                                }
                            }
                        }
                        .padding(.horizontal, 24)

                    }
                    .padding(.bottom, 24)
                } else {
                    Text(viewModel.message ?? "Loan not found.")
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    viewModel.downloadPDF()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.down.to.line")
                        Text("Download Calculation")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppTheme.textPrimary)
                    )
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .padding(.bottom, 16)
                .background(Color.white)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.configure(context: context)
            viewModel.load(loanID: loanID)
        }
        .sheet(item: $viewModel.shareItem) { item in
            ShareSheet(activityItems: [item.url])
        }
    }

    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(AppTheme.textPrimary)
        }
    }
}
