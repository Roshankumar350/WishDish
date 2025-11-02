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
    var sampleItems: [MenuList.MenuItem]!

    override func setUp() {
        super.setUp()
        viewModel = InvoiceViewModel()
        sampleItems = [
            MenuList.MenuItem(id: 1, name: "Pizza", description: "Cheesy", category: "Family Dining", price: 250, isAvailable: true, isPopular: true, isVegetarian: true, imageUrl: "", dietaryFlags: [], prepTimeMinutes: 10, spiceLevel: 1, quantity: 2)
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
    
    func testInvoiceIncludesMineralWater() {
        let items = [
            MenuList.MenuItem(id: 100, name: "Mineral Water", description: "500ml", category: "Extras", price: 30, isAvailable: true, isPopular: false, isVegetarian: true, imageUrl: "", dietaryFlags: [], prepTimeMinutes: 0, spiceLevel: 0, quantity: 2)
        ]
        viewModel.createInvoice(from: items, tipText: "10", feedback: "", emoji: nil)
        let invoice = viewModel.invoices.first!
        XCTAssertEqual(invoice.totalAmount, 70.0)
    }

}

