//
//  LoanDetailsPDFRenderer.swift
//  Calculator
//
//  Created by fin on 09/01/2026.
//

import UIKit

struct LoanDetailsPDFRenderer: LoanDetailsPDFRendering {
    func render(details: LoanDetailsDisplay) -> Result<Data, DomainError> {
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

        let data = renderer.pdfData { context in
            context.beginPage()
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 22),
                .foregroundColor: UIColor.black
            ]
            let subtitleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.gray
            ]
            let valueAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 28),
                .foregroundColor: UIColor(red: 0/255, green: 100/255, blue: 28/255, alpha: 1)
            ]
            let sectionAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 16),
                .foregroundColor: UIColor.black
            ]
            let rowTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.gray
            ]
            let rowValueAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 13),
                .foregroundColor: UIColor.black
            ]

            let padding: CGFloat = 40
            var y: CGFloat = 36

            draw(text: "Loan Calculation", attributes: titleAttributes, x: padding, y: y, width: pageRect.width - padding * 2)
            y += 32

            draw(text: details.title, attributes: sectionAttributes, x: padding, y: y, width: pageRect.width - padding * 2)
            y += 22

            draw(text: "Total Amount Payable (KES)", attributes: subtitleAttributes, x: padding, y: y, width: pageRect.width - padding * 2)
            y += 22
            draw(text: details.totalPayableText, attributes: valueAttributes, x: padding, y: y, width: pageRect.width - padding * 2)
            y += 36

            for row in details.detailRows {
                draw(text: row.title, attributes: rowTitleAttributes, x: padding, y: y, width: pageRect.width - padding * 2)
                let valueSize = row.value.size(withAttributes: rowValueAttributes)
                draw(text: row.value, attributes: rowValueAttributes, x: pageRect.width - padding - valueSize.width, y: y, width: valueSize.width)
                y += 22
            }

            y += 8
            drawDivider(y: y, width: pageRect.width - padding * 2)
            y += 18

            draw(text: "Repayment Schedule", attributes: sectionAttributes, x: padding, y: y, width: pageRect.width - padding * 2)
            y += 24

            for item in details.repaymentItems {
                draw(text: item.title, attributes: rowTitleAttributes, x: padding, y: y, width: pageRect.width - padding * 2)
                let amountSize = item.amount.size(withAttributes: rowValueAttributes)
                draw(text: item.amount, attributes: rowValueAttributes, x: pageRect.width - padding - amountSize.width, y: y, width: amountSize.width)
                y += 22
            }
        }

        return .success(data)
    }

    private func draw(text: String, attributes: [NSAttributedString.Key: Any], x: CGFloat, y: CGFloat, width: CGFloat) {
        let rect = CGRect(x: x, y: y, width: width, height: 24)
        text.draw(in: rect, withAttributes: attributes)
    }

    private func drawDivider(y: CGFloat, width: CGFloat) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 40, y: y))
        path.addLine(to: CGPoint(x: 40 + width, y: y))
        UIColor.lightGray.setStroke()
        path.lineWidth = 1
        path.stroke()
    }
}
