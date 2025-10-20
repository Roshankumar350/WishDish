//
//  InvoiceViewModelTests.swift
//  WishDishTests
//
//  Created by Roshan Sah on 20/10/25.
//

import XCTest
@testable import WishDish

final class InvoiceViewModelTests: XCTestCase {
    var viewModel: InvoiceViewModel!
    var sampleItems: [MenuItem]!

    override func setUp() {
        super.setUp()
        viewModel = InvoiceViewModel()
        sampleItems = [
            MenuItem(id: 1, name: "Pizza", description: "Cheesy", category: "Family Dining", price: 250, isAvailable: true, isPopular: true, isVegetarian: true, imageUrl: "", dietaryFlags: [], prepTimeMinutes: 10, spiceLevel: 1, quantity: 2)
        ]
    }

    func testCreateInvoiceWithoutTipOrFeedback() {
        viewModel.createInvoice(from: sampleItems, tipText: "", feedback: "", emoji: nil)
        XCTAssertEqual(viewModel.invoices.count, 1)
        XCTAssertEqual(viewModel.invoices.first?.tip, 0)
        XCTAssertNil(viewModel.invoices.first?.feedback)
    }

    func testCreateInvoiceWithTipAndFeedback() {
        viewModel.createInvoice(from: sampleItems, tipText: "50", feedback: "Great!", emoji: "😊")
        let invoice = viewModel.invoices.first
        XCTAssertEqual(invoice?.tip, 50)
        XCTAssertEqual(invoice?.feedback, "😊 Great!")
    }

    func testInvoiceGroupingByDate() {
        viewModel.createInvoice(from: sampleItems, tipText: "10", feedback: "", emoji: nil)
        let grouped = viewModel.invoicesGroupedByDate
        XCTAssertEqual(grouped.count, 1)
    }

    func testInvoiceSubtotalAndTaxes() {
        viewModel.createInvoice(from: sampleItems, tipText: "50", feedback: "", emoji: nil)
        let invoice = viewModel.invoices.first!
        let expectedTax = (invoice.totalAmount - invoice.tip) * 0.09
        XCTAssertEqual(invoice.sgst, expectedTax, accuracy: 0.01)
        XCTAssertEqual(invoice.cgst, expectedTax, accuracy: 0.01)
        XCTAssertEqual(invoice.subtotal, invoice.totalAmount - invoice.tip - invoice.sgst - invoice.cgst, accuracy: 0.01)
    }
}

