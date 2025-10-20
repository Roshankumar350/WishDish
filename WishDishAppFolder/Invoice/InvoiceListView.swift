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
    }
    @ObservedObject var viewModel: InvoiceViewModel

    var body: some View {
        NavigationStack {
            if viewModel.formattedInvoices.isEmpty {
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
                .padding()
            } else {
                List {
                    ForEach(viewModel.invoicesGroupedByDate.keys.sorted(), id: \.self) { dateKey in
                        Section(header: Text(dateKey).sectionHeaderText()) {
                            ForEach(viewModel.invoicesGroupedByDate[dateKey] ?? []) { invoice in
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(invoice.items, id: \.id) { item in
                                        HStack {
                                            Text("\(item.name) x \(item.quantity)")
                                                .bodyText()
                                            Spacer()
                                            Text("₹\(Double(item.quantity) * item.price, specifier: "%.2f")")
                                                .priceText()
                                        }
                                    }

                                    Divider()

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
                                    
                                    if let feedback = invoice.feedback {
                                        HStack(alignment: .top) {
                                            Text(Constant.feedback)
                                                .captionText()
                                                .frame(width: 80, alignment: .leading)

                                            VStack(alignment: .trailing, spacing: 4) {
                                                if let emoji = feedback.first, emoji.isEmoji {
                                                    Text(String(emoji))
                                                        .font(.system(size: 28))
                                                }
                                                let note = String(feedback.dropFirst().trimmingCharacters(in: .whitespaces))
                                                if !note.isEmpty {
                                                    Text(note)
                                                        .captionText()
                                                        .foregroundColor(.secondary)
                                                }
                                            }
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                        }
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }

            }
        }
        .navigationTitle(Constant.yourInvoices)
    }
}
