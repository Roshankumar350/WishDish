//
//  InvoiceListView.swift
//  WishDish
//
//  Created by Roshan Sah on 12/10/25.
//

import SwiftUI
import Foundation

struct InvoiceListView: View {
    struct Constant {
        static let docIcon = "doc.text.magnifyingglass"
        static let noInvoicesText = "No invoices yet"
        static let yourInvoicesText = "Your invoices will appear here once you place an order."
        static let tip = "Tip"
        static let sgst = "SGST @ 9%"
        static let cgst = "CGST @ 9%"
        static let total = "Total"
        static let feedback = "Feedback:"
        static let yourInvoices = "Your Invoices"
        static let yourInvoicesSummery = "Your Invoice Summary"
    }
    
    @ObservedObject var viewModel: InvoiceViewModel
    
    var body: some View {
        NavigationStack {
            if viewModel.sortedInvoices.isEmpty {
                EmptyView()
                    .padding()
            } else {
                List {
                    ForEach(viewModel.invoicesGroupedByDate.keys.sorted(), id: \.self) { dateKey in
                        Section(header: Text(dateKey).sectionHeaderText()) {
                            ForEach(viewModel.invoicesGroupedByDate[dateKey] ?? []) { invoice in
                                NavigationLink {
                                    InvoiceCircularChart(rawComponents: viewModel.getInvoiceComponent(for: invoice))
                                } label: {
                                    LazyVStack(alignment: .leading, spacing: 8) {
                                        ForEach(invoice.items, id: \.id) { item in
                                            CellView(item: item)
                                        }
                                        Divider()
                                        ChargesView(invoice: invoice)
                                        if let feedback = invoice.feedback {
                                            FeedbackView(feedback: feedback)
                                        }
                                    }
                                    .padding(.vertical, 8)
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle(Constant.yourInvoices)
    }
}

// MARK: Feedback View
extension InvoiceListView {
    struct FeedbackView: View {
        let feedback: String
        
        var body: some View {
            HStack(alignment: .top) {
                Text(InvoiceListView.Constant.feedback)
                    .captionText()
                    .frame(width: 80, alignment: .leading)
                
                VStack(alignment: .trailing, spacing: 4) {
                    if let emoji = parsedEmoji {
                        Text(emoji)
                            .font(.system(size: 28))
                    }
                    
                    if let note = parsedNote, !note.isEmpty {
                        Text(note)
                            .captionText()
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        
        private var parsedEmoji: String? {
            guard let first = feedback.first,
                  first.unicodeScalars.first?.properties.isEmojiPresentation == true else {
                return nil
            }
            return String(first)
        }
        
        private var parsedNote: String? {
            let trimmed = feedback.dropFirst().trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? nil : trimmed
        }
    }
}

// MARK: Charges View
extension InvoiceListView {
    struct ChargesView: View {
        let invoice: Invoice
        
        var body: some View {
            HStack {
                Text(Constant.tip).captionText()
                Spacer()
                Text("₹\(invoice.tip, specifier: "%.2f")").priceText()
            }
            
            HStack {
                Text(Constant.sgst).captionText()
                Spacer()
                Text("₹\(invoice.sgst, specifier: "%.2f")").priceText()
            }
            
            HStack {
                Text(Constant.cgst).captionText()
                Spacer()
                Text("₹\(invoice.cgst, specifier: "%.2f")").priceText()
            }
            
            Divider()
            
            HStack {
                Text(Constant.total).sectionHeaderText()
                Spacer()
                Text("₹\(invoice.totalAmount, specifier: "%.2f")").titleText()
            }
        }
    }
}

// MARK: Supplementary View
extension InvoiceListView {
    struct EmptyView: View {
        
        var body: some View {
            VStack(spacing: 16) {
                Image(systemName: Constant.docIcon)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
                
                Text(Constant.noInvoicesText)
                    .emptyStateText()
                
                Text(Constant.yourInvoicesText)
                    .emptyStateText()
            }
        }
    }
    
    struct CellView: View {
        let item: MenuList.MenuItem
        var body: some View {
            HStack {
                Text("\(item.name) x \(item.quantity)")
                    .bodyText()
                Spacer()
                Text("₹\(Double(item.quantity) * item.price, specifier: "%.2f")")
                    .priceText()
            }
        }
    }
}
