//
//  InvoiceViewModel.swift
//  WishDish
//
//  Created by Roshan Sah on 12/10/25.
//

import Combine
import Foundation

class InvoiceViewModel: ObservableObject {
    @Published var invoices: [Invoice] = []

    func addInvoice(_ invoice: Invoice) {
        invoices.append(invoice)
    }

    func createInvoice(from items: [MenuList.MenuItem], tipText: String, feedback: String, emoji: String?) {
        let tip = Double(tipText) ?? 0
        let total = items.reduce(0) { $0 + Double($1.quantity) * $1.price }

        let combinedFeedback: String? = {
            if let emoji = emoji, !feedback.isEmpty {
                return "\(emoji) \(feedback)"
            } else if let emoji = emoji {
                return emoji
            } else if !feedback.isEmpty {
                return feedback
            } else {
                return nil
            }
        }()

        let invoice = Invoice(
            id: UUID(),
            date: Date(),
            items: items,
            totalAmount: total + tip,
            tip: tip,
            feedback: combinedFeedback
        )

        addInvoice(invoice)
    }

    var formattedInvoices: [Invoice] {
        invoices.sorted(by: { $0.date > $1.date })
    }

    var invoicesGroupedByDate: [String: [Invoice]] {
        Dictionary(grouping: formattedInvoices) { invoice in
            invoice.date.formatted(date: .abbreviated, time: .omitted)
        }
    }
}

