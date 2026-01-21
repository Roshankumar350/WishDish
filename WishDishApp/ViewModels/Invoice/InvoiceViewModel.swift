//
//  InvoiceViewModel.swift
//  WishDish
//
//  Created by Roshan Sah on 12/10/25.
//

import Combine
import Foundation

final class InvoiceViewModel: ObservableObject {
    //MARK: - Attribute
    /// list of invoices
    @Published var invoices: [Invoice] = []

    //MARK: - Behaviours
    
    /// Add invoice to `invoices`
    func addInvoice(_ invoice: Invoice) {
        invoices.append(invoice)
    }

    /// Create  and add Invoice
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

        let invoice = Invoice(id: UUID(), date: Date(), items: items, totalAmount: total + tip, tip: tip, feedback: combinedFeedback)
        addInvoice(invoice)
    }

    /// Ordered invoice
    var sortedInvoices: [Invoice] {
        invoices.sorted(by: { $0.date > $1.date })
    }

    /// Grouped invoice by date
    var invoicesGroupedByDate: [String: [Invoice]] {
        Dictionary(grouping: sortedInvoices) { invoice in
            invoice.date.formatted(date: .abbreviated, time: .omitted)
        }
    }

    func getInvoices() -> [InvoiceComponent] {
        var invoiceComponet = [InvoiceComponent]()
        let calendar = Calendar.current
        
        let groupedByMonth = Dictionary(grouping: invoices) { invoice -> Date in
            let components = calendar.dateComponents([.year, .month], from: invoice.date)
            return calendar.date(from: components) ?? invoice.date
        }
        
        for (eachKey, eachValue) in groupedByMonth {
            let totalAmount = eachValue.reduce(0) { partialResult, invoice in
                partialResult + invoice.totalAmount
            }
            invoiceComponet.append(InvoiceComponent(label: "\(eachKey.formatted(date: .abbreviated, time: .omitted))", amount: totalAmount))
        }
        return invoiceComponet
    }
    
    func getInvoiceComponent(for selectedInvoice: Invoice) -> [InvoiceComponent] {
        var expectation = [InvoiceComponent]()
        
        selectedInvoice.items.forEach { item in
            expectation.append(InvoiceComponent(label: item.name, amount: item.price))
        }
        
        return expectation
    }
}

