//
//  MenuList.swift
//  WishDish
//
//  Created by Roshan Sah on 09/10/25.
//

import Foundation

struct MenuList: Decodable {
    let items: [MenuItem]
    let meta: Meta
}

struct Meta: Decodable {
    let page: Int
    let limit: Int
    let total: Int
}
struct MenuItem: Decodable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let category: String
    let price: Double
    let isAvailable: Bool
    let isPopular: Bool
    let isVegetarian: Bool
    let imageUrl: String
    let dietaryFlags: [String]
    let prepTimeMinutes: Int
    let spiceLevel: Int
    var quantity: Int = 0

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case category
        case price
        case isAvailable = "is_available"
        case isPopular = "is_popular"
        case isVegetarian = "is_vegetarian"
        case imageUrl = "image_url"
        case dietaryFlags = "dietary_flags"
        case prepTimeMinutes = "prep_time_minutes"
        case spiceLevel = "spice_level"
    }
}

extension MenuItem {
    var moodCategory: MoodCategory {
        MoodCategory(rawValue: self.category) ?? .familyDining
    }
}
