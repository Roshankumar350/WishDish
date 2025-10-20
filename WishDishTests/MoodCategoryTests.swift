//
//  MoodCategoryTests.swift
//  WishDishTests
//
//  Created by Roshan Sah on 20/10/25.
//

import XCTest
@testable import WishDish

final class MoodCategoryTests: XCTestCase {
    func testCategoryNameMapping() {
        XCTAssertEqual(MoodCategory.familyDining.categoryName, "Family Dining")
        XCTAssertEqual(MoodCategory.spicyAdventure.imageName, "spicyAdventure")
    }
}

