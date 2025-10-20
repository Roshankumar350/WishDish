//
//  Character+Extension.swift
//  WishDish
//
//  Created by Roshan Sah on 19/10/25.
//

import Foundation

extension Character {
    var isEmoji: Bool {
        unicodeScalars.first?.properties.isEmojiPresentation ?? false
    }
}
