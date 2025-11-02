//
//  MenuItemTests.swift
//  WishDishTests
//
//  Created by Roshan Sah on 20/10/25.
//

import XCTest
@testable import WishDish

final class MenuItemTests: XCTestCase {
    func testMoodCategoryMapping() {
        let item = MenuList.MenuItem(
            id: 1,
            name: "Paneer Tikka",
            description: "Spicy grilled paneer",
            category: "Spicy Adventure",
            price: 180,
            isAvailable: true,
            isPopular: true,
            isVegetarian: true,
            imageUrl: "",
            dietaryFlags: ["Vegetarian"],
            prepTimeMinutes: 15,
            spiceLevel: 3
        )

        XCTAssertEqual(item.moodCategory, .spicyAdventure)
    }
}

