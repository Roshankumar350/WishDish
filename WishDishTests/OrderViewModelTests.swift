//
//  OrderViewModelTests.swift
//  WishDishTests
//
//  Created by Roshan Sah on 08/10/25.
//

import XCTest
@testable import WishDish

final class OrderViewModelTests: XCTestCase {
    var orderVM: OrderViewModel!
    var menuVM: MenuViewModel!

    override func setUp() {
        super.setUp()
        menuVM = MenuViewModel(loader: MockLoader(menuItems: [
            MenuItem(id: 100, name: "Mineral Water", description: "500ml", category: "Extras", price: 30, isAvailable: true, isPopular: false, isVegetarian: true, imageUrl: "", dietaryFlags: [], prepTimeMinutes: 0, spiceLevel: 0),
            MenuItem(id: 1, name: "Pizza", description: "Cheesy", category: "Family Dining", price: 250, isAvailable: true, isPopular: true, isVegetarian: true, imageUrl: "", dietaryFlags: [], prepTimeMinutes: 10, spiceLevel: 1)
        ]))
        orderVM = OrderViewModel()
        orderVM.menuVM = menuVM
    }

    func testSelectedItemsWithWaterIncludesMineralWater() {
        orderVM.incrementMineralWater()
        let items = orderVM.selectedItemsWithWater
        XCTAssertTrue(items.contains { $0.name == "Mineral Water" })
        XCTAssertEqual(items.first(where: { $0.name == "Mineral Water" })?.quantity, 1)
    }

    func testConfirmOrderIncludesMineralWater() {
        orderVM.incrementMineralWater()
        orderVM.confirmOrder()
        let order = orderVM.currentOrder
        XCTAssertNotNil(order)
        XCTAssertTrue(order!.items.contains { $0.name == "Mineral Water" })
    }

    func testSubtotalIncludesMineralWaterPrice() {
        orderVM.incrementMineralWater()
        orderVM.confirmOrder()
        let total = orderVM.currentOrder!.items.reduce(0) { $0 + Double($1.quantity) * $1.price }
        XCTAssertEqual(total, 30.0)
    }
}

