//
//  StringExtensionsTests.swift
//  WishDishTests
//
//  Created by Roshan Sah on 20/10/25.
//

import XCTest
@testable import WishDish

final class CharacterExtensionsTests: XCTestCase {
    func testIsEmojiTrueForSimpleEmoji() {
        let emoji: Character = "😊"
        XCTAssertTrue(emoji.isEmoji)
    }

    func testIsEmojiTrueForCompoundEmoji() {
        let emoji: Character = "👨‍👩‍👧‍👦".first!
        XCTAssertTrue(emoji.isEmoji)
    }

    func testIsEmojiFalseForLetter() {
        let letter: Character = "A"
        XCTAssertFalse(letter.isEmoji)
    }

    func testIsEmojiFalseForDigit() {
        let digit: Character = "5"
        XCTAssertFalse(digit.isEmoji)
    }

    func testIsEmojiFalseForSymbol() {
        let symbol: Character = "+"
        XCTAssertFalse(symbol.isEmoji)
    }
}

