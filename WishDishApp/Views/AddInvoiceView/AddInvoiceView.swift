//
//  AddInvoiceView.swift
//  WishDish
//
//  Created by Roshan Sah on 12/10/25.
//

import Foundation
import SwiftUI

struct AddInvoiceView: View {
    private struct Constant {
        static let yourSelection = "Your Selection"
        static let extras = "Extras"
        static let pluseIcon = "plus.circle.fill"
        static let addInvoice = "Add Invoice"
        static let invoiceAddedSuccessfully = "Invoice added successfully!"
    }

    @ObservedObject var viewModel: InvoiceViewModel
    @ObservedObject var orderVM: OrderViewModel
    @Binding var selectedTab: Int

    @State private var tipText: String = ""
    @State private var feedback: String = ""
    @State private var selectedEmoji: String? = nil
    @State private var showToast = false

    let emojiOptions = ["😍", "😊", "😐", "😠"]

    var body: some View {
        let items = orderVM.currentOrder?.items ?? []

        ZStack {
            if items.isEmpty {
                EmptyInvoiceView(selectedTab: $selectedTab)
            } else {
                VStack(spacing: 16) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(Constant.yourSelection)
                                .sectionHeaderText()
                                .padding(.horizontal)
                                .padding(.top)

                            ForEach(items) { item in
                                InvoiceItemCard(item: item)
                            }

                            Text(Constant.extras)
                                .sectionHeaderText()
                                .padding(.horizontal)
                                .padding(.top)

                            TipAndFeedbackSection(
                                tipText: $tipText,
                                feedback: $feedback,
                                selectedEmoji: $selectedEmoji,
                                emojiOptions: emojiOptions
                            )
                        }
                        .padding(.top)
                    }

                    Button(action: {
                        viewModel.createInvoice(from: items, tipText: tipText, feedback: feedback, emoji: selectedEmoji)

                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

                        withAnimation { showToast = true }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation { showToast = false }
                            resetSelection()
                            selectedTab = 2
                        }
                    }) {
                        HStack {
                            Image(systemName: Constant.pluseIcon)
                            Text(Constant.addInvoice)
                                .buttonText()
                        }
                        .primaryButtonStyle()
                    }
                    .padding(.bottom)
                }
            }

            if showToast {
                ToastView(message: Constant.invoiceAddedSuccessfully)
            }
        }
        .navigationTitle(Constant.addInvoice)
    }

    func resetSelection() {
        orderVM.clearOrder()
        tipText = ""
        feedback = ""
        selectedEmoji = nil
    }
}


//MARK: - EmptyInvoiceView
extension AddInvoiceView {
    
    struct EmptyInvoiceViewConstant {
        static let menucard = "menucard"
        static let noItemsSelected = "No items selected"
        static let browseMenuOrExploreMoods = "Browse the menu or explore moods to add items to your invoice."
        static let goToMenu = "Go to Menu"
        static let exploreMoods = "Explore Moods"
        static let checkPreviousInvoices = "Check Previous Invoices"
    }
    
    struct EmptyInvoiceView: View {
        @Binding var selectedTab: Int

        var body: some View {
            VStack(spacing: 24) {
                Image(systemName: EmptyInvoiceViewConstant.menucard)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)

                Text(EmptyInvoiceViewConstant.noItemsSelected)
                    .emptyStateText()

                Text(EmptyInvoiceViewConstant.browseMenuOrExploreMoods)
                    .customTextStyle(font: .body, color: .secondary, alignment: .center)
                    .padding(.horizontal)

                VStack(spacing: 12) {
                    Button(action: { selectedTab = 1 }) {
                        Text(EmptyInvoiceViewConstant.goToMenu)
                            .customTextStyle(font: .headline, color: .white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }

                    Button(action: { selectedTab = 0 }) {
                        Text(EmptyInvoiceViewConstant.exploreMoods)
                            .customTextStyle(font: .subheadline, color: .blue)
                    }

                    Button(action: { selectedTab = 2 }) {
                        Text(EmptyInvoiceViewConstant.checkPreviousInvoices)
                            .customTextStyle(font: .subheadline, color: .blue)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

//MARK: - InvoiceItemCard
extension AddInvoiceView {
    struct InvoiceItemCard: View {
        let item: MenuList.MenuItem

        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(item.name) x \(item.quantity)")
                        .customTextStyle(font: .headline)
                    Text("₹\(Double(item.quantity) * item.price, specifier: "%.2f")")
                        .priceText()
                }
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            .padding(.horizontal)
        }
    }

}

//MARK: - ToastView
extension AddInvoiceView {
    struct ToastView: View {
        let message: String

        var body: some View {
            VStack {
                Spacer()
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                        Text(message)
                            .toastText()
                    }
                    .padding()
                    .background(Color.green.opacity(0.95))
                    .cornerRadius(12)
                    .shadow(radius: 10)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.3).ignoresSafeArea())
            .transition(.scale.combined(with: .opacity))
            .animation(.easeInOut(duration: 0.3), value: true)
        }
    }

}

//MARK: - TipAndFeedbackSection
extension AddInvoiceView {
    struct AddInvoiceConstant {
        static let tip = "Enter tip amount"
        static let howWasYourExperience = "How was your experience?"
        static let addQuickNote = "Add a quick note"
    }
    struct TipAndFeedbackSection: View {
        @Binding var tipText: String
        @Binding var feedback: String
        @Binding var selectedEmoji: String?
        let emojiOptions: [String]
        
        var body: some View {
            VStack(spacing: 12) {
                TextField(AddInvoiceConstant.tip, text: $tipText)
                    .keyboardType(.decimalPad)
                    .inputFieldStyle()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(AddInvoiceConstant.howWasYourExperience)
                        .customTextStyle(font: .subheadline, color: .secondary)
                        .padding(.horizontal)
                    
                    HStack(spacing: 16) {
                        ForEach(emojiOptions, id: \.self) { emoji in
                            Text(emoji)
                                .font(.largeTitle)
                                .padding(8)
                                .background(selectedEmoji == emoji ? Color.blue.opacity(0.2) : Color.clear)
                                .cornerRadius(8)
                                .onTapGesture {
                                    selectedEmoji = emoji
                                }
                        }
                    }
                    .padding(.horizontal)
                    
                    TextField(AddInvoiceConstant.addQuickNote, text: $feedback)
                        .submitLabel(.done)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
        }
    }
}
