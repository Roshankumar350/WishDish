//
//  RootTabViewModelTests.swift
//  WishDishTests
//
//  Created by Roshan Sah on 20/10/25.
//

import XCTest
@testable import WishDish

final class RootTabViewModelTests: XCTestCase {
    var viewModel: RootTabViewModel!

    override func setUp() {
        super.setUp()
        viewModel = RootTabViewModel()
        viewModel.menuItems = [
            MenuItem(id: 1, name: "Pasta", description: "Creamy", category: "Family Dining", price: 150, isAvailable: true, isPopular: true, isVegetarian: true, imageUrl: "", dietaryFlags: [], prepTimeMinutes: 10, spiceLevel: 1),
            MenuItem(id: 2, name: "Mineral Water", description: "Bottled", category: "Extras", price: 30, isAvailable: true, isPopular: false, isVegetarian: true, imageUrl: "", dietaryFlags: [], prepTimeMinutes: 0, spiceLevel: 0)
        ]
    }

    func testIncrementDecrementQuantity() {
        let item = viewModel.menuItems[0]
        viewModel.incrementQuantity(for: item)
        XCTAssertEqual(viewModel.menuItems[0].quantity, 1)
        viewModel.decrementQuantity(for: item)
        XCTAssertEqual(viewModel.menuItems[0].quantity, 0)
    }

    func testMineralWaterQuantity() {
        viewModel.incrementMineralWater()
        viewModel.incrementMineralWater()
        XCTAssertEqual(viewModel.mineralWaterQuantity, 2)
        viewModel.decrementMineralWater()
        XCTAssertEqual(viewModel.mineralWaterQuantity, 1)
    }

    func testSelectedItemsWithWater() {
        viewModel.incrementQuantity(for: viewModel.menuItems[0])
        viewModel.incrementMineralWater()
        let selected = viewModel.selectedItemsWithWater
        XCTAssertEqual(selected.count, 2)
        XCTAssertTrue(selected.contains { $0.name == "Mineral Water" })
    }

    func testClearSelectedItems() {
        viewModel.incrementQuantity(for: viewModel.menuItems[0])
        viewModel.clearSelectedItems()
        XCTAssertEqual(viewModel.menuItems[0].quantity, 0)
    }

    func testConfirmOrderCreatesOrder() {
        viewModel.incrementQuantity(for: viewModel.menuItems[0])
        viewModel.confirmOrder()
        XCTAssertNotNil(viewModel.currentOrder)
        XCTAssertEqual(viewModel.currentOrder?.items.count, 1)
    }

    func testOrderStatusUpdate() {
        viewModel.incrementQuantity(for: viewModel.menuItems[0])
        viewModel.confirmOrder()
        viewModel.updateOrderStatus(to: .served)
        XCTAssertEqual(viewModel.currentOrder?.status, .served)
    }
    
    func testMenuLoadingFromMockJSON() throws {
        let loader = FileBasedMockLoader()
        let items = try loader.load([MenuItem].self, from: "MockMenuList")
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items.first?.name, "Mock Pizza")
    }

    func testCorruptJSONThrowsError() {
        let loader = FileBasedMockLoader()
        XCTAssertThrowsError(try loader.load([MenuItem].self, from: "CorruptMenuList"))
    }

}

