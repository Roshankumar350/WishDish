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
        
        init(id: Int, name: String, description: String, category: String, price: Double,
             isAvailable: Bool, isPopular: Bool, isVegetarian: Bool, imageUrl: String,
             dietaryFlags: [String], prepTimeMinutes: Int, spiceLevel: Int, quantity: Int = 0) {
            self.id = id
            self.name = name
            self.description = description
            self.category = category
            self.price = price
            self.isAvailable = isAvailable
            self.isPopular = isPopular
            self.isVegetarian = isVegetarian
            self.imageUrl = imageUrl
            self.dietaryFlags = dietaryFlags
            self.prepTimeMinutes = prepTimeMinutes
            self.spiceLevel = spiceLevel
            self.quantity = quantity
        }

    }
    
    struct Meta: Decodable {
        let page: Int
        let limit: Int
        let total: Int
    }
}

extension MenuList.MenuItem {
    var moodCategory: MoodCategory {
        MoodCategory(rawValue: self.category) ?? .familyDining
    }
}

extension MenuList.MenuItem {
    func withUpdatedQuantity(_ newQuantity: Int) -> MenuList.MenuItem {
        MenuList.MenuItem(id: id,
                 name: name,
                 description: description,
                 category: category,
                 price: price,
                 isAvailable: isAvailable,
                 isPopular: isPopular,
                 isVegetarian: isVegetarian,
                 imageUrl: imageUrl,
                 dietaryFlags: dietaryFlags,
                 prepTimeMinutes: prepTimeMinutes,
                 spiceLevel: spiceLevel,
                 quantity: newQuantity)
    }
}

