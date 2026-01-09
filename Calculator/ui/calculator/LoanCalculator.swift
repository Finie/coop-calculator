//
//  LoanCalculator.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import SwiftUI

struct LoanCalculator: View {
    
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var popupPresenter: PopupPresenter
    @Environment(\.dismiss) private var dismiss
    
    private enum Field { case principal, rate, months }

    @StateObject private var viewModel = LoanCalculatorViewModel()
    
    @FocusState private var focusedField: Field?
    
    @State private var isLoanTypeSheetPresented = false
    
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
                    Text("Calculate Loan")
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
                VStack(spacing: 28) {
                VStack(spacing: 8) {
                    Text("Total Amount Payable (KES)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(viewModel.totalPayableText)
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(AppTheme.accent)
                        .minimumScaleFactor(0.8)
                }
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)

                    VStack(spacing: 18) {
                        fieldLabel("Loan Type")
                        Button {
                            focusedField = nil
                            isLoanTypeSheetPresented = true
                        } label: {
                        HStack {
                            Text(viewModel.loanTypeLabel)
                                .foregroundColor(viewModel.isLoanTypeSelected ? .primary : .secondary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 14)
                            .padding(.horizontal, 16)
                            .background(fieldBackground)
                        }

                        fieldLabel("Loan Interest (%)")
                        TextField("15.00", text: $viewModel.rate)
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .rate)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 16)
                            .background(fieldBackground)

                        fieldLabel("Loan Amount")
                        HStack(spacing: 12) {
                            Text("KES")
                                .foregroundColor(.secondary)
                            Divider()
                                .frame(height: 18)
                            TextField("10,000.00", text: $viewModel.principal)
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .principal)
                        }
                        .padding(.vertical, 14)
                        .padding(.horizontal, 16)
                        .background(fieldBackground)

                        fieldLabel("Loan Period (months)")
                        TextField("2", text: $viewModel.months)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .months)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 16)
                            .background(fieldBackground)
                    }
                    .padding(.horizontal, 20)

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Repayment Schedule")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(AppTheme.textPrimary)

                    ForEach(viewModel.repaymentItems) { item in
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
                    .padding(.horizontal, 20)

                    Button("Save Calculation") { viewModel.save() }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppTheme.textPrimary)
                        )
                        .padding(.horizontal, 20)

                    if let message = viewModel.message {
                        Text(message)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom, 24)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
        .onAppear { viewModel.configure(context: context) }
        .onReceive(viewModel.$popup) { popup in
            guard let popup else { return }
            // VM emits popup content; view forwards it to the presenter.
            popupPresenter.show(popup)
            viewModel.clearPopup()
        }
        .sheet(isPresented: $isLoanTypeSheetPresented) {
            VStack(spacing: 16) {
                Capsule()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(width: 48, height: 5)
                    .padding(.top, 8)

                Text("Loan Types")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.secondary)

                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(viewModel.loanTypeOptions) { option in
                            Button {
                                viewModel.selectLoanType(option)
                                isLoanTypeSheetPresented = false
                            } label: {
                                HStack {
                                    Text(option.title)
                                        .font(.headline)
                                        .foregroundColor(AppTheme.textPrimary)
                                    Spacer()
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 18)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(
                                            viewModel.loanTypeLabel == option.title
                                            ? AppTheme.textPrimary.opacity(0.12)
                                            : Color.white
                                        )
                                )
                                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
            }
            .background(Color.white)
            .presentationDetents([.medium])
            .presentationDragIndicator(.hidden)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var fieldBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
            )
    }

    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
